# OverGate RC4 install — bootstrap note (IN_PROGRESS)

Status: **IN_PROGRESS** — apply + helpers + project verify complete; later checkpoints
(fresh-session hook activation probes, Windows checklist, finalize, merge) are explicitly
NOT RUN by this note. Not a readiness or merge-readiness claim.

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
- Independent PLAN_READY obtained via PM from a separate reviewer before any write
  (plan SHA256 `9f9dade37c9488b1a3d52c486b14ac5422a25b0926f89ee4bfd6d98afd695cd8`); evidence
  published at
  https://github.com/komleff/overgate-rc4-wi1-smoke-20261028/pull/1#issuecomment-6472783557 .
  No drift between the reviewed plan and the state at apply time.
- `apply` run (exit 0); backup journal at
  `.overgate-backups/015cf86a07e34fa4b49a9ed4064ff6cd/rollback.json` (git-ignored, local only).
- Helpers run strictly in order, all exit 0: `og-init-memory-bank.sh` (six Memory Bank files
  created), `bd-bootstrap.sh` (Beads ready, `origin/beads-backup` published), `og-protect-main.sh`
  (branch protection on `main` verified: PR required / 0 approvals, `enforce_admins: true`,
  `allow_force_pushes: false`, `allow_deletions: false`, confirmed via API readback).
- `.agents/project/verify.sh` filled with a minimal project-owned smoke test (README
  presence/non-emptiness/UTF-8, `.overgate/install-state.json` source SHA/mode/beads, presence
  of required public entrypoints) and run: **PASS**. `python3 scripts/check-reference.py`:
  **PASS**.
- Re-running `install-overgate.py plan` after apply is a no-op: 73/73 operations with
  `before == after`, 0 conflicts (read-only re-check; no new approval/apply needed for this
  no-op confirmation).
- Not run / explicitly deferred: fresh native-session hook-activation probes (this session's
  own post-apply hook behavior is not treated as that proof), Windows simple/complex-path
  checklist, `finalize-pr`, operator merge. Merge is reserved for the operator.
