#!/usr/bin/env python3
"""Build a KerML 10.3 project archive (.kpar) of libraries/.

The archive is a ZIP holding the textual model units plus two manifests:
.project.json (name, version, license, website, usage) and .meta.json
(root-namespace index, metamodel URI, creation time, SHA-256 checksums) —
the shape sysml-toolkit and the normative SysML-v2-Release archives use:
deflate entries, zeroed DOS dates, sorted entries, so the output is
byte-deterministic for a given tree.

Usage: build-kpar.py --version X.Y.Z --output PATH
"""

import argparse
import hashlib
import json
import re
import subprocess
import sys
import zipfile
from pathlib import Path

METAMODEL = "https://www.omg.org/spec/SysML/20250201"
PROJECT_NAME = "OpenSysML Extension Libraries"
WEBSITE = "https://github.com/Open-MBEE/OpenSysML-Extensions-Library"
DESCRIPTION = (
    "Community non-normative SysML v2 and KerML extension libraries, "
    "maintained in the OpenSysML-Extensions-Library repository."
)

PACKAGE_RE = re.compile(r"^(?:standard\s+)?library\s+package\s+([A-Za-z_][A-Za-z0-9_]*)", re.M)


def top_level_package(source: str, stem: str) -> str:
    match = PACKAGE_RE.search(source)
    return match.group(1) if match else stem


def head_commit_time(repo_root: Path) -> str:
    out = subprocess.run(
        ["git", "-C", str(repo_root), "log", "-1", "--format=%cI", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    # Normalize to UTC ISO-8601 for reproducibility across build machines.
    from datetime import datetime, timezone

    return datetime.fromisoformat(out).astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", required=True, help="archive version, e.g. 1.2.0")
    parser.add_argument("--output", required=True, help="path of the .kpar to write")
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    libraries = repo_root / "libraries"
    unit_paths = sorted(
        p for p in libraries.iterdir() if p.suffix in (".sysml", ".kerml") and p.is_file()
    )
    if not unit_paths:
        print(f"error: {libraries} holds no .sysml or .kerml file", file=sys.stderr)
        return 1

    units = []  # (unit path, source bytes, root package name)
    for path in unit_paths:
        source = path.read_bytes()
        text = source.decode("utf-8")
        units.append((path.name, source, top_level_package(text, path.stem)))

    project = {
        "name": PROJECT_NAME,
        "version": args.version,
        "description": DESCRIPTION,
        "license": "Apache-2.0",
        "website": WEBSITE,
        "usage": [],
    }
    meta = {
        "index": {root: name for name, _, root in units},
        "created": head_commit_time(repo_root),
        "metamodel": METAMODEL,
        "checksum": {
            name: {"value": hashlib.sha256(data).hexdigest(), "algorithm": "SHA256"}
            for name, data, _ in units
        },
    }

    entries = [
        (".project.json", json.dumps(project, separators=(",", ":")).encode()),
        (".meta.json", json.dumps(meta, separators=(",", ":")).encode()),
    ] + [(name, data) for name, data, _ in units]
    entries.sort(key=lambda e: e[0])

    # The normative archives' fixed timestamp: 1980-01-01 00:00.
    epoch = (1980, 1, 1, 0, 0, 0)
    output = Path(args.output)
    with zipfile.ZipFile(output, "w") as archive:
        for name, data in entries:
            info = zipfile.ZipInfo(name, date_time=epoch)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0
            info.create_system = 0
            archive.writestr(info, data)

    print(f"Wrote {output} ({len(units)} units, version {args.version})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
