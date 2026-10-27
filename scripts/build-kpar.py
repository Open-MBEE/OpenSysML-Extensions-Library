#!/usr/bin/env python3
"""Build the KerML 10.3 project archive (.kpar) of this repository.

The repository root is the project: `.project.json` and `.meta.json` there
are the archive's manifests, and the archive holds exactly the units and
files `.meta.json` checksums, at their repository paths (`libraries/...`),
so a tag's tree and its archive are one project. Nothing in the archive
comes from this script; it first runs write-project-meta.py --check so a
manifest that drifted from the tree is never archived.

    build-kpar.py [--version X.Y.Z] [--output PATH]

`--version` is the version the caller expects (release.yml passes the tag);
it must equal `.project.json` `version`, so a mistagged release fails here
instead of publishing a mismatch. The archive is byte-deterministic for a
tree: deflate entries, 1980-01-01 DOS dates, sorted names.
"""

import argparse
import importlib.util
import json
import re
import sys
import zipfile
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parent
ROOT = SCRIPTS.parent


def load_write_project_meta():
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location("write_project_meta", SCRIPTS / "write-project-meta.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def slug(name: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def archive_members(meta: dict) -> list:
    """Every file the metadata checksums, plus the two manifests."""
    members = set(meta["checksum"])
    for unit in meta["index"].values():
        if unit not in members:
            raise ValueError(f".meta.json indexes {unit} but holds no checksum for it")
    return sorted(members | {".project.json", ".meta.json"})


def write_archive(output: Path, members: list) -> None:
    epoch = (1980, 1, 1, 0, 0, 0)
    with zipfile.ZipFile(output, "w") as archive:
        for name in members:
            info = zipfile.ZipInfo(name, date_time=epoch)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0
            info.create_system = 0
            archive.writestr(info, (ROOT / name).read_bytes())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--version", help="version the archive must carry; must equal .project.json's")
    parser.add_argument("--output", type=Path, help="archive path (default: <project-slug>-<version>.kpar)")
    args = parser.parse_args()

    checker = load_write_project_meta()
    try:
        project, meta = checker.check_tree(ROOT)
    except checker.Failure as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    if args.version is not None and args.version != project["version"]:
        print(
            f"error: --version {args.version} does not equal .project.json version {project['version']}; "
            "bump .project.json in a release-prep commit and tag that",
            file=sys.stderr,
        )
        return 1

    output = args.output or Path(f"{slug(project['name'])}-{project['version']}.kpar")
    try:
        members = archive_members(meta)
    except ValueError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    write_archive(output, members)
    print(f"Wrote {output} ({project['name']} {project['version']}, {len(members)} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
