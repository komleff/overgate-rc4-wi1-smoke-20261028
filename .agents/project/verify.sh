#!/usr/bin/env bash
# Project-owned minimal verification for this README-only smoke-test project.
# Checks installed state/presence only; does not re-implement installer hashing/manifest logic.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# 1. README present, non-empty, valid UTF-8.
[[ -s README.md ]] || fail "README.md missing or empty"
python3 -c "
import sys
with open('README.md', 'rb') as f:
    data = f.read()
try:
    data.decode('utf-8')
except UnicodeDecodeError as e:
    sys.exit('README.md is not valid UTF-8: %s' % e)
" || fail "README.md UTF-8 check failed"

# 2. Install-state: exact source SHA, mode, beads.
STATE=".overgate/install-state.json"
[[ -f "$STATE" ]] || fail "$STATE missing"
python3 -c "
import json, sys
with open('$STATE', encoding='utf-8') as f:
    state = json.load(f)
expected_sha = '75677f9c9bc79ed8831df3251e374771a3a02b23'
if state.get('source_sha') != expected_sha:
    sys.exit('source_sha mismatch: got %r, expected %r' % (state.get('source_sha'), expected_sha))
if state.get('mode') not in ('auto', 'bypass', 'custom'):
    sys.exit('unexpected mode: %r' % state.get('mode'))
if not isinstance(state.get('beads'), bool):
    sys.exit('beads field missing or not boolean: %r' % state.get('beads'))
" || fail "install-state.json checks failed"

# 3. Required installed public entrypoints present (and executable where applicable).
check_present() {
  [[ -e "$1" ]] || fail "missing required entrypoint: $1"
}
check_exec() {
  check_present "$1"
  [[ -x "$1" ]] || fail "required entrypoint not executable: $1"
}

check_present ".agents/INSTALL.md"
check_exec   "scripts/install-overgate.py"
check_exec   "scripts/og-init-memory-bank.sh"
check_exec   "scripts/og-protect-main.sh"
check_present "scripts/check-reference.py"

BEADS_ENABLED=$(python3 -c "
import json
with open('$STATE', encoding='utf-8') as f:
    print(json.load(f).get('beads'))
")
if [[ "$BEADS_ENABLED" == "True" ]]; then
  check_exec "scripts/bd-bootstrap.sh"
fi

echo "verify.sh: PASS"
