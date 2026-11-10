# Projects

One folder per project. Create one with:

```bash
bash scripts/new-project.sh <slug> [A-K]
```

Each project folder is its own local git repository (`projects/<slug>/.git`), so
every module, fix, and security finding has a traceable commit:

```bash
bash scripts/git-save.sh <slug> "feat(module-3): orders list + tests"
```

Work one module at a time and record it in the project's `STATUS.md`:

- build the module;
- test it: `bash scripts/test-local.sh <slug> --check --path /<route>`;
- commit it;
- write the row: module, route, test evidence, commit id.

Before handoff the project must pass the security gate
(`workflow/06-security-audit.md`): `bash scripts/security-audit.sh <slug>`
exits 0 and `security/REPORT.md` is written.

Do not keep secrets here. The `.env` and `.dev.vars` files are ignored by git.
