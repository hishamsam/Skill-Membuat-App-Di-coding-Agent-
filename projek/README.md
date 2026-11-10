# Projects

One folder per project. Create one with:

```bash
bash skrip/new-project.sh <slug> [A-K]
```

Each project folder is its own local git repository (`projek/<slug>/.git`), so
every module, fix, and security finding has a traceable commit:

```bash
bash skrip/git-save.sh <slug> "feat(module-3): orders list + tests"
```

Work one module at a time and record it in the project's `STATUS.md`:

- build the module;
- test it: `bash skrip/test-local.sh <slug> --check --path /<route>`;
- commit it;
- write the row: module, route, test evidence, commit id.

Before handoff the project must pass the security gate
(`aliran-kerja/06-security-audit.md`): `bash skrip/security-audit.sh <slug>`
exits 0 and `security/REPORT.md` is written.

Do not keep secrets here. The `.env` and `.dev.vars` files are ignored by git.
