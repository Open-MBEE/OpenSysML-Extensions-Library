#!/usr/bin/env bash
# Check that README.md's library table and libraries/ agree: every file gets
# exactly one table row, every row names an existing file, and the file stem is
# the top-level package the file declares.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
libraries="$repo_root/libraries"
readme="$repo_root/README.md"

fail=0

for file in "$libraries"/*.sysml "$libraries"/*.kerml; do
	[[ -e "$file" ]] || continue
	name="$(basename "$file")"
	stem="${name%.*}"
	rows="$(grep -cF "| $name |" "$readme" || true)"
	if [[ "$rows" -ne 1 ]]; then
		echo "error: $name has $rows README table row(s), expected exactly one" >&2
		fail=1
	fi
	package="$(sed -nE 's/^(standard )?library package ([A-Za-z_][A-Za-z0-9_]*).*/\2/p' "$file" | head -1)"
	if [[ "$package" != "$stem" ]]; then
		echo "error: $name declares top-level package '${package:-<none>}', expected $stem" >&2
		fail=1
	fi
done

# Every File-column entry must name a file that exists in libraries/.
while IFS= read -r entry; do
	[[ -n "$entry" ]] || continue
	if [[ ! -f "$libraries/$entry" ]]; then
		echo "error: README table names $entry, which is not in libraries/" >&2
		fail=1
	fi
done < <(grep -oE '\| [A-Za-z0-9_]+\.(sysml|kerml) \|' "$readme" | tr -d '| ')

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "README table matches libraries/"
