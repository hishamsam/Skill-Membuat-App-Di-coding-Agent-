# Environment preflight for the WebApp Builder skill (native Windows).
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preflight.ps1 [-Install] [-Json] [-Stack A-K]
#
# Reads scripts/tools.tsv, reports every selected tool, and with -Install installs
# the missing ones through winget. It never prompts for credentials, never
# upgrades an existing runtime, and never installs Docker, Flutter, or FigCraft
# by itself. ASCII only; Windows PowerShell 5.1 compatible.

[CmdletBinding()]
param(
    [switch]$Install,
    [switch]$Json,
    [string]$Stack = ""
)

$ErrorActionPreference = 'Continue'

$Root = Split-Path -Parent $PSScriptRoot
$Catalog = Join-Path $PSScriptRoot 'tools.tsv'

if ($Stack -ne '' -and $Stack -notmatch '^[A-K]$') {
    [Console]::Error.WriteLine('Usage: preflight.ps1 [-Install] [-Json] [-Stack A-K]')
    exit 1
}

if (-not (Test-Path -LiteralPath $Catalog)) {
    [Console]::Error.WriteLine('preflight: cannot read scripts/tools.tsv')
    exit 3
}

function Get-ToolVersion {
    param([string]$Command, [string]$VersionArgs)
    $out = $null
    try {
        if ([string]::IsNullOrWhiteSpace($VersionArgs)) {
            $out = & $Command 2>&1
        }
        else {
            $out = & $Command $VersionArgs 2>&1
        }
    }
    catch {
        return ''
    }
    if (-not $out) { return '' }
    $first = @($out)[0]
    return ([string]$first).Trim()
}

function Resolve-Tool {
    param([string]$Check)
    if ($Check -eq '__python_markdown__') {
        $python = Get-Command python3 -ErrorAction SilentlyContinue
        if (-not $python) { return $false }
        & python3 -c "import markdown" 2>&1 | Out-Null
        return ($LASTEXITCODE -eq 0)
    }
    $cmd = Get-Command $Check -ErrorAction SilentlyContinue
    return ($null -ne $cmd)
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $parts = @()
    if ($machine) { $parts += $machine }
    if ($user) { $parts += $user }
    $env:Path = ($parts -join ';')
}

$tools = @()
$blocking = @()
$installAttempted = $false
$restartRequired = $false
$failedInstall = $false

$winget = Get-Command winget -ErrorAction SilentlyContinue

$rows = Import-Csv -Path $Catalog -Delimiter '|'
foreach ($row in $rows) {
    if ([string]::IsNullOrWhiteSpace($row.id)) { continue }
    $tier = $row.tier.Trim()
    $include = $false
    if ($tier -eq 'core' -or $tier -eq 'optional') { $include = $true }
    elseif ($tier -like 'stack:*') {
        if ($Stack -ne '' -and $tier.Substring(6) -eq $Stack) { $include = $true }
    }
    if (-not $include) { continue }

    $id = $row.id.Trim()
    $check = $row.check.Trim()
    $versionArgs = ''
    if ($row.version_args) { $versionArgs = $row.version_args.Trim() }
    $hint = ''
    if ($row.manual_hint) { $hint = $row.manual_hint.Trim() }

    $version = ''
    $found = Resolve-Tool $check
    if ($found -and $check -ne '__python_markdown__') {
        $version = Get-ToolVersion $check $versionArgs
    }
    if ($found -and $check -eq '__python_markdown__') {
        $version = 'importable'
    }

    $status = 'ok'
    if (-not $found) { $status = 'missing' }
    if ($check -eq 'node' -and $found) {
        $major = $version.TrimStart('v')
        $major = ($major -split '\.')[0]
        $number = 0
        if ([int]::TryParse($major, [ref]$number)) {
            if ($number -lt 20) {
                $status = 'outdated'
                $hint = 'Node 20 or newer is required. Install the current LTS release with: winget install --id OpenJS.NodeJS.LTS --exact'
            }
        }
    }

    $action = $null

    if ($Install -and $status -eq 'missing') {
        $wingetId = ''
        if ($row.winget) { $wingetId = $row.winget.Trim() }

        if ($tier -eq 'optional') {
            if ($wingetId -ne '') {
                $action = 'winget install --id ' + $wingetId + ' --exact'
            }
        }
        elseif ($id -eq 'figcraft' -or $id -eq 'figcraft-cli') {
            $status = 'manual'
        }
        elseif (-not $winget) {
            $status = 'manual'
            $hint = 'Install App Installer from the Microsoft Store (or https://aka.ms/getwinget), then rerun preflight.'
        }
        elseif ($wingetId -eq '') {
            $status = 'manual'
            if ($hint -ne '') { $hint = $hint + ' ' }
            $hint = $hint + 'No Windows package mapping in scripts/tools.tsv; install it manually.'
        }
        else {
            $installAttempted = $true
            $action = 'winget install --id ' + $wingetId + ' --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements'
            $output = & winget install --id $wingetId --exact --silent --disable-interactivity --accept-package-agreements --accept-source-agreements 2>&1 | Out-String
            $code = $LASTEXITCODE
            if ($code -ne 0) {
                $failedInstall = $true
                $status = 'failed'
                $lines = $output -split "`r?`n" | Where-Object { $_.Trim() -ne '' }
                if ($lines.Count -gt 0) { $hint = ([string]$lines[$lines.Count - 1]).Trim() }
            }
            else {
                Refresh-Path
                $again = Resolve-Tool $check
                if ($again) {
                    $status = 'installed'
                    $version = Get-ToolVersion $check $versionArgs
                }
                else {
                    $status = 'installed'
                    $restartRequired = $true
                    $hint = 'Restart the agent session to pick up PATH changes.'
                }
            }
        }
    }

    $tools += [ordered]@{
        id      = $id
        tier    = $tier
        check   = $check
        status  = $status
        version = $(if ($version -eq '') { $null } else { $version })
        action  = $action
        hint    = $(if ($hint -eq '') { $null } else { $hint })
    }
}

# bash is not a catalog row; the workflow scripts need it.
$bashVersion = ''
$bashStatus = 'manual'
$bashHint = 'Install Git for Windows (Git.Git) so the workflow scripts can run.'
$bashCmd = Get-Command bash -ErrorAction SilentlyContinue
if ($bashCmd) {
    $bashStatus = 'ok'
    $bashVersion = Get-ToolVersion 'bash' '--version'
}
elseif ($env:ProgramFiles) {
    $candidate = Join-Path $env:ProgramFiles 'Git\bin\bash.exe'
    if (Test-Path -LiteralPath $candidate) {
        $bashStatus = 'ok'
        $bashVersion = Get-ToolVersion $candidate '--version'
        $bashHint = $null
    }
}
$tools += [ordered]@{
    id      = 'bash'
    tier    = 'core'
    check   = 'bash'
    status  = $bashStatus
    version = $(if ($bashVersion -eq '') { $null } else { $bashVersion })
    action  = $null
    hint    = $bashHint
}

# FigCraft live mode is informational; Phase 2 always needs a Linux host here.
$liveStatus = 'info'
$liveHint = 'Phase 2 needs live mode: figcraft --control 7979'
$listening = $null
try {
    $listening = Get-NetTCPConnection -LocalPort 7979 -State Listen -ErrorAction SilentlyContinue
}
catch {
    $listening = $null
}
if ($listening) {
    $liveStatus = 'ok'
    $liveHint = $null
}
$tools += [ordered]@{
    id      = 'figcraft-live'
    tier    = 'info'
    check   = 'figcraft-live'
    status  = $liveStatus
    version = $null
    action  = $null
    hint    = $liveHint
}

$phase1 = $true
foreach ($tool in $tools) {
    if ($tool.tier -ne 'core') { continue }
    if ($tool.status -notin @('missing', 'manual', 'failed')) { continue }
    if ($tool.id -eq 'figcraft' -or $tool.id -eq 'figcraft-cli') { continue }
    $phase1 = $false
    $blocking += $tool.id
}

$phase2 = $false
if ($phase1) {
    $phase2 = $true
    foreach ($need in @('figcraft', 'figcraft-cli')) {
        $match = $tools | Where-Object { $_.id -eq $need } | Select-Object -First 1
        if ($null -eq $match) { $phase2 = $false; continue }
        if ($match.status -notin @('ok', 'installed')) { $phase2 = $false }
    }
}

$report = [ordered]@{
    os                = 'windows'
    packageManager    = $(if ($winget) { 'winget' } else { 'none' })
    installAttempted  = [bool]$installAttempted
    ready             = [ordered]@{ phase1 = [bool]$phase1; phase2 = [bool]$phase2 }
    restartRequired   = [bool]$restartRequired
    blocking          = @($blocking)
    platformNote      = 'FigCraft is distributed for Linux/macOS. Phase 2 requires a Linux host; use WSL2 Ubuntu when Phase 2 starts.'
    tools             = @($tools)
}

$jsonText = $report | ConvertTo-Json -Compress -Depth 5

if ($Json) {
    Write-Output $jsonText
}
else {
    Write-Output ('Environment check - windows (' + $report.packageManager + ')')
    foreach ($tool in $tools) {
        switch ($tool.status) {
            'ok' { $label = 'OK' }
            'missing' { $label = 'MISSING' }
            'installed' { $label = 'INSTALLED' }
            'manual' { $label = 'MANUAL' }
            'outdated' { $label = 'OUTDATED' }
            'failed' { $label = 'FAILED' }
            default { $label = 'INFO' }
        }
        $shown = ''
        if ($tool.version) {
            $shown = [string]$tool.version
            if ($shown.Length -gt 72) { $shown = $shown.Substring(0, 69) + '...' }
        }
        if ($shown -ne '') {
            Write-Output ('  {0,-9} {1} {2}' -f $label, $tool.id, $shown)
        }
        else {
            Write-Output ('  {0,-9} {1}' -f $label, $tool.id)
        }
        if ($tool.status -ne 'ok' -and $tool.action) {
            Write-Output ('            -> ' + $tool.action)
        }
        if ($tool.status -ne 'ok' -and $tool.hint) {
            Write-Output ('            hint: ' + $tool.hint)
        }
    }
    if ($phase1 -and $phase2) {
        Write-Output 'Result: Phase 1 ready, Phase 2 ready.'
    }
    elseif ($phase1) {
        Write-Output 'Result: Phase 1 ready, Phase 2 not ready (FigCraft).'
    }
    else {
        Write-Output ('Result: Phase 1 not ready (blocked: ' + ($blocking -join ',') + ').')
    }
    Write-Output ('PREFLIGHT_JSON ' + $jsonText)
}

if ($phase1) { exit 0 }
if ($failedInstall) { exit 2 }
exit 3
