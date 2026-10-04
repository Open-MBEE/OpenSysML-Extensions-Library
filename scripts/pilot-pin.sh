#!/usr/bin/env bash
# Single source of the OMG SysML v2 Pilot Implementation pin, sourced by every
# script that fetches or verifies something from it: the reference validator
# the library gate runs.
#
# Kept in one file so the release under comparison cannot drift between them.
# The tag names the release; the commit is what every fetch verifies, because a
# tag is a mutable ref and the baselines record content. Change them together.
PILOT_TAG="${PILOT_TAG:-2026-08}"
PILOT_COMMIT="${PILOT_COMMIT:-692170b71867353b8f90341e61556f49a5beb0e5}"
PILOT_REPO="${PILOT_REPO:-https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation.git}"
PILOT_ARTIFACT_VERSION="${PILOT_ARTIFACT_VERSION:-0.62.0}"

# pilot_pin is the stamp a fetched destination records.
pilot_pin() {
	printf '%s %s %s' "$PILOT_TAG" "$PILOT_COMMIT" "$PILOT_REPO"
	return 0
}

# pilot_recover_dir puts back the $1.old backup an interrupted pilot_install_dir left behind.
pilot_recover_dir() {
	local dst="$1"
	if [[ ! -e "$dst" ]] && [[ -e "$dst.old" ]]; then
		mv "$dst.old" "$dst"
	fi
	return 0
}

# pilot_install_dir replaces directory $2 with $1, keeping the old copy as
# $2.old until the rename into place succeeds and restoring it if that fails.
pilot_install_dir() {
	local src="$1" dst="$2"
	mkdir -p "$(dirname "$dst")"
	pilot_recover_dir "$dst"
	rm -rf "$dst.new" "$dst.old"
	if ! mv "$src" "$dst.new"; then
		rm -rf "$dst.new"
		return 1
	fi
	if [[ -e "$dst" ]] && ! mv "$dst" "$dst.old"; then
		rm -rf "$dst.new"
		return 1
	fi
	if ! mv "$dst.new" "$dst"; then
		pilot_recover_dir "$dst"
		rm -rf "$dst.new"
		return 1
	fi
	rm -rf "$dst.old"
	return 0
}
