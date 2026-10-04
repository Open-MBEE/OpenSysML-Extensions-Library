#!/usr/bin/env python3
"""Validate engine-contract.json and write the flat TSV the Java checker reads.

Each line is `name TAB kind TAB comma-separated-parameters-or-attributes`
(the third field is empty for package, document and element entries).

Usage: check-engine-contract.py [MANIFEST] > entries.tsv
"""

import json
import sys
from pathlib import Path

KINDS = {"package", "function", "metadata", "document", "element"}
QUALIFIED_NAME = __import__("re").compile(r"[A-Za-z_][A-Za-z0-9_]*(::[A-Za-z_][A-Za-z0-9_]*)*")


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def main() -> int:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "engine-contract.json"
    try:
        manifest = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as e:
        fail(f"{path}: {e}")

    if not isinstance(manifest.get("contract"), int) or isinstance(manifest["contract"], bool):
        fail("contract must be an integer")
    entries = manifest.get("entries")
    if not isinstance(entries, list):
        fail("entries must be a list")

    names = []
    for index, entry in enumerate(entries):
        if not isinstance(entry, dict):
            fail(f"entries[{index}] is not an object")
        name = entry.get("name")
        if not isinstance(name, str) or not QUALIFIED_NAME.fullmatch(name):
            fail(f"entries[{index}]: bad name {name!r}")
        kind = entry.get("kind")
        if kind not in KINDS:
            fail(f"{name}: unknown kind {kind!r}")
        if kind == "function":
            parameters = entry.get("parameters")
            if not isinstance(parameters, list) or not all(isinstance(p, str) for p in parameters):
                fail(f"{name}: function entries require a parameters list of names")
        elif kind == "metadata":
            attributes = entry.get("attributes")
            if not isinstance(attributes, list) or not all(isinstance(a, str) for a in attributes):
                fail(f"{name}: metadata entries require an attributes list of names")
        consumers = entry.get("consumers", [])
        if not isinstance(consumers, list) or not all(isinstance(c, str) for c in consumers):
            fail(f"{name}: consumers must be a list of repo-relative paths")
        names.append(name)

    if len(set(names)) != len(names):
        duplicates = sorted({n for n in names if names.count(n) > 1})
        fail(f"duplicate entries: {', '.join(duplicates)}")
    if names != sorted(names):
        fail("entries are not sorted by name")

    for entry in entries:
        spec = entry.get("parameters", entry.get("attributes", [])) or []
        print(f"{entry['name']}\t{entry['kind']}\t{','.join(spec)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
