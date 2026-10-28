# OverGate RC4 install — bootstrap note (IN_PROGRESS)

Status: **IN_PROGRESS** — plan stage only. Not a readiness or acceptance claim.

This note tracks the OverGate v4.0.0-rc.4 (WI-1) installation attempt into this smoke-test
project, per `.agents/INSTALL.md` from the source checkout. Full machine-local artifacts
(Verification Contract, generated plan JSON, approval evidence) live outside this repo under
`/tmp/` on the installer machine and are referenced here by hash, not by local path.

## Identity

- Source (read-only): clean trusted Git checkout, exact SHA
  `75677f9c9bc79ed8831df3251e374771a3a02b23`.
- Target: this repository, working branch `install/overgate-rc4-auto`, branched from `main`
  at `76e40adfbf5d3393d0393c629fddccb141a61cdf`.
- Project authority: operator (no project AGENTS.md exists yet; authority defaults to
  operator per source `.agents/INSTALL.md`).

## Plan-stage summary

A Verification Contract was prepared for this install, covering:
- Preserved README (present, non-empty, UTF-8).
- Exact source SHA pinned above.
- Operator product authority, existing checks, and any custom hooks preserved.
- `.agents/project/verify.sh` to be filled, after `apply`, with a minimal smoke test that
  checks README presence/non-emptiness/UTF-8, `.overgate/install-state.json`
  (source SHA / mode / beads), and presence of the required installed public entrypoints
  (`.agents/INSTALL.md`, `scripts/install-overgate.py`, `scripts/og-init-memory-bank.sh`,
  `scripts/bd-bootstrap.sh`, `scripts/og-protect-main.sh`, `scripts/check-reference.py`),
  without mirroring the installer's own implementation/hashing logic.
- Installed structural checker (`scripts/check-reference.py`) to be run in target post-apply.
- All other acceptance/helper/rollback/protection behavior follows source `.agents/INSTALL.md`
  unmodified.

## Qualification status

- Prerequisites checked on the installer machine: git, bash, python3, gh (authenticated),
  jq, node, `bd` 1.2.2 — all present; no Beads reinstall performed.
- Target inventory confirmed: single `README.md`, clean checkout at the seed commit, public
  GitHub repo, default branch `main`, no pre-existing branches besides `main`, no pre-existing
  PRs.
- No managed OverGate payload has been written to this target yet. This commit is docs-only.
- `install-overgate.py plan` (no target writes) and its SHA256 are to be published on the
  associated Draft PR for this branch.
- Independent PLAN_READY has **not** been obtained yet. `apply` and the post-apply helpers
  (`og-init-memory-bank.sh`, `bd-bootstrap.sh`, `og-protect-main.sh`) have **not** run.
- This note will be updated as later stages (apply, helpers, verify.sh, check-reference.py)
  complete. Merge is reserved for the operator.
