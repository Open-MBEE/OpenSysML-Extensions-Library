#!/usr/bin/env bash
# Verify the pinned pilot tag still resolves to the pinned commit, without
# cloning anything. Fails when the tag has moved or been deleted.
set -euo pipefail

# shellcheck source=scripts/pilot-pin.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pilot-pin.sh"

refs="$(git ls-remote "$PILOT_REPO" "refs/tags/$PILOT_TAG" "refs/tags/$PILOT_TAG^{}")"
if [[ -z "$refs" ]]; then
	echo "error: $PILOT_REPO has no tag $PILOT_TAG, which scripts/pilot-pin.sh pins" >&2
	exit 1
fi

# An annotated tag lists two refs: the tag object and its peeled commit.
resolved=""
while IFS=$'\t' read -r sha ref; do
	if [[ "$ref" == "refs/tags/$PILOT_TAG^{}" ]]; then
		resolved="$sha"
	elif [[ "$ref" == "refs/tags/$PILOT_TAG" ]] && [[ -z "$resolved" ]]; then
		resolved="$sha"
	fi
done <<<"$refs"

if [[ "$resolved" != "$PILOT_COMMIT" ]]; then
	echo "error: $PILOT_REPO tag $PILOT_TAG resolves to $resolved, scripts/pilot-pin.sh pins $PILOT_COMMIT" >&2
	echo "       the release tag has moved: investigate what changed before re-pinning the commit," >&2
	echo "       or override it together with PILOT_TAG deliberately" >&2
	exit 1
fi

echo "Pin verified: $PILOT_REPO tag $PILOT_TAG is $PILOT_COMMIT"
