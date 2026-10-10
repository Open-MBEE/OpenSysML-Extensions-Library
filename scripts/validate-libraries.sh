#!/usr/bin/env bash
# The library gate: run the pinned OMG pilot batch validator over libraries/
# and require zero errors and zero warnings, except the warnings allow-listed
# in validation/allowed-warnings.txt. The allow-list is a ratchet: every entry
# must be emitted by the current run (a stale entry fails) and entries are
# only ever deleted, never added.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
libraries="$repo_root/libraries"
allowed="$repo_root/validation/allowed-warnings.txt"
validator="$repo_root/build/pilot-sysml-validator/validate-sysml-batch"
sysml_library="$repo_root/build/pilot-validator/target/sysml-download/sysml/sysml.library"

if [[ -z "$(find "$libraries" -type f \( -name '*.sysml' -o -name '*.kerml' \) -print -quit)" ]]; then
	echo "error: $libraries holds no .sysml or .kerml file" >&2
	exit 1
fi

"$repo_root/scripts/download-pilot-sysml-validator.sh"

if [[ ! -x "$validator" ]]; then
	echo "error: batch validator not found at $validator" >&2
	exit 1
fi

output="$(mktemp)"
trap 'rm -f "$output"' EXIT

status=0
# --root makes diagnostics name each file by its name inside libraries/, which
# is how validation/allowed-warnings.txt records them.
"$validator" --library "$sysml_library" --root "$libraries" "$libraries" >"$output" 2>&1 || status=$?
cat "$output"
if [[ "$status" -ne 0 ]]; then
	echo "error: the pilot validator exited with status $status" >&2
	exit 1
fi

# Only file:line:col diagnostics count; log4j noise on stderr does not match.
diagnostics="$(grep -E '^[^:]+:[0-9]+:[0-9]+: (error|warning): ' "$output" || true)"

fail=0
if [[ -n "$diagnostics" ]]; then
	while IFS= read -r line; do
		if [[ "$line" == *": error: "* ]]; then
			echo "error: $line" >&2
			fail=1
		elif ! grep -Fqx "$line" <(grep -v '^\s*#' "$allowed" | grep -v '^\s*$'); then
			echo "error: warning not in validation/allowed-warnings.txt: $line" >&2
			fail=1
		fi
	done <<<"$diagnostics"
fi

# A stale allow-list entry — one the current run did not emit — fails too.
while IFS= read -r entry; do
	[[ "$entry" =~ ^[[:space:]]*(#|$) ]] && continue
	if ! grep -Fqx "$entry" <<<"$diagnostics"; then
		echo "error: stale allow-list entry not emitted by this run: $entry" >&2
		fail=1
	fi
done <"$allowed"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi

count="$(grep -cE '^[^:]+:[0-9]+:[0-9]+: (error|warning): ' <<<"$diagnostics" || true)"
echo "Validation clean: 0 errors, $count warning(s)"
