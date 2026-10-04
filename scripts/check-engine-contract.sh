#!/usr/bin/env bash
# Check engine-contract.json: schema and sorted/unique entries (Python side),
# resolution and kind/parameter/attribute conformance against the pinned pilot
# (Java side). With --base REF, also diff against the manifest at REF and
# classify breaking changes; a breaking change requires `contract` to be
# bumped, which then means the next release must be a MAJOR version and an
# OpenSysML PR must re-pin its vendored copy.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_root/engine-contract.json"
libraries="$repo_root/libraries"
checker="$repo_root/build/pilot-sysml-validator/check-engine-contract"
sysml_library="$repo_root/build/pilot-validator/target/sysml-download/sysml/sysml.library"

base=""
while [[ $# -gt 0 ]]; do
	case "$1" in
		--base)
			base="${2:?--base needs a ref}"
			shift 2
			;;
		*)
			echo "error: unknown argument: $1" >&2
			exit 2
			;;
	esac
done

tsv="$(mktemp)"
trap 'rm -f "$tsv" "$tsv.py.err"' EXIT

if ! python3 "$repo_root/scripts/check-engine-contract.py" "$manifest" >"$tsv" 2>"$tsv.py.err"; then
	cat "$tsv.py.err" >&2
	exit 1
fi

"$repo_root/scripts/download-pilot-sysml-validator.sh" >/dev/null
if [[ ! -x "$checker" ]]; then
	echo "error: contract checker not found at $checker" >&2
	exit 1
fi
"$checker" "$sysml_library" "$libraries" "$tsv"

if [[ -z "$base" ]]; then
	exit 0
fi

if ! base_manifest="$(git -C "$repo_root" show "$base:engine-contract.json" 2>/dev/null)"; then
	echo "No engine-contract.json at $base; skipping the compatibility diff."
	exit 0
fi

base_json="$(mktemp --suffix=.json)"
trap 'rm -f "$tsv" "$tsv.py.err" "$base_json"' EXIT
printf '%s' "$base_manifest" >"$base_json"

python3 - "$base_json" "$manifest" <<'PY'
import json
import sys

base = json.load(open(sys.argv[1]))
head = json.load(open(sys.argv[2]))
base_entries = {e["name"]: e for e in base.get("entries", [])}
head_entries = {e["name"]: e for e in head.get("entries", [])}
base_contract = base.get("contract")
head_contract = head.get("contract")
bumped = isinstance(head_contract, int) and isinstance(base_contract, int) and head_contract > base_contract

breaking = []
for name, old in base_entries.items():
    new = head_entries.get(name)
    if new is None:
        breaking.append(f"{name}: entry removed")
        continue
    if new.get("kind") != old.get("kind"):
        breaking.append(f"{name}: kind {old.get('kind')} -> {new.get('kind')}")
    if old.get("kind") == "function" and new.get("parameters") != old.get("parameters"):
        breaking.append(f"{name}: parameters {old.get('parameters')} -> {new.get('parameters')}")
    if old.get("kind") == "metadata":
        removed = [a for a in old.get("attributes", []) if a not in new.get("attributes", [])]
        if removed:
            breaking.append(f"{name}: attributes removed: {', '.join(removed)}")

if not breaking:
    sys.exit(0)

for line in breaking:
    print(f"engine-contract: breaking change: {line}", file=sys.stderr)
if bumped:
    print("contract bumped "
          f"{base_contract} -> {head_contract}: the next release must be a MAJOR version "
          "and an OpenSysML PR must re-pin its vendored copy.")
    sys.exit(0)
print("error: breaking engine-contract changes require bumping `contract`",
      file=sys.stderr)
sys.exit(1)
PY
