#!/usr/bin/env python3
"""Write or check the project interchange manifests at the repository root.

The repository is a KerML 10.3 project: `.project.json` (KerML 1.0 Table 12)
names it and the OMG standard-library archives it uses, and `.meta.json`
(Table 13) indexes the root namespace each unit under libraries/ declares,
with a SHA-256 checksum per unit (and the license), the metamodel IRI and the
creation time. A tagged commit of the tree is the project; build-kpar.py only
archives what these files record.

    write-project-meta.py          rewrite .meta.json from the tree
    write-project-meta.py --check  fail when .project.json or .meta.json
                                   disagree with the tree (CI)

Both modes check .project.json: the Table 12 fields are present, `version` is
semver, and `usage` is exactly the OMG archives whose root namespaces the
units import or reference. The usage list is derived, never guessed: every
`import` root and every qualified-name root (`Base::…`) outside comments and
strings is looked up in the index of the OMG 20250201 archives below; a root
no library here or there declares is an error.
"""

import argparse
import hashlib
import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECT_FILE = ".project.json"
META_FILE = ".meta.json"
LIBRARIES_DIR = "libraries"
LICENSE_FILE = "LICENSE"
UNIT_SUFFIXES = (".kerml", ".sysml")

METAMODEL_KERML = "https://www.omg.org/spec/KerML/20250201"
METAMODEL_SYSML = "https://www.omg.org/spec/SysML/20250201"

REQUIRED_FIELDS = ("name", "publisher", "description", "version", "license", "website", "usage")
EXPECTED_PUBLISHER = "Open-MBEE"

# https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
SEMVER_RE = re.compile(
    r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
    r"(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?"
    r"(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"
)

# The root namespaces each OMG standard-library archive declares: the `index`
# of the archive's own .meta.json, corrected to the names the units declare
# (the Requirement Derivation index says RequirementsDerivation for a unit
# declaring RequirementDerivation; USCustomaryUnits is also known as USCU).
OMG_ARCHIVES = {
    "https://www.omg.org/spec/KerML/20250201/Semantic-Library.kpar": (
        "Base", "Clocks", "ControlPerformances", "FeatureReferencingPerformances", "KerML",
        "Links", "Metaobjects", "Objects", "Observation", "Occurrences", "Performances",
        "SpatialFrames", "StatePerformances", "Transfers", "TransitionPerformances", "Triggers",
    ),
    "https://www.omg.org/spec/KerML/20250201/Data-Type-Library.kpar": (
        "Collections", "ScalarValues", "VectorValues",
    ),
    "https://www.omg.org/spec/KerML/20250201/Function-Library.kpar": (
        "BaseFunctions", "BooleanFunctions", "CollectionFunctions", "ComplexFunctions",
        "ControlFunctions", "DataFunctions", "IntegerFunctions", "NaturalFunctions",
        "NumericalFunctions", "OccurrenceFunctions", "RationalFunctions", "RealFunctions",
        "ScalarFunctions", "SequenceFunctions", "StringFunctions", "TrigFunctions", "VectorFunctions",
    ),
    "https://www.omg.org/spec/SysML/20250201/Systems-Library.kpar": (
        "Actions", "Allocations", "AnalysisCases", "Attributes", "Calculations", "Cases",
        "Connections", "Constraints", "Flows", "Interfaces", "Items", "Metadata", "Parts", "Ports",
        "Requirements", "StandardViewDefinitions", "States", "SysML", "UseCases",
        "VerificationCases", "Views",
    ),
    "https://www.omg.org/spec/SysML/20250201/Analysis-Domain-Library.kpar": (
        "AnalysisTooling", "SampledFunctions", "StateSpaceRepresentation", "TradeStudies",
    ),
    "https://www.omg.org/spec/SysML/20250201/Cause-and-Effect-Domain-Library.kpar": (
        "CausationConnections", "CauseAndEffect",
    ),
    "https://www.omg.org/spec/SysML/20250201/Geometry-Domain-Library.kpar": (
        "ShapeItems", "SpatialItems",
    ),
    "https://www.omg.org/spec/SysML/20250201/Metadata-Domain-Library.kpar": (
        "ImageMetadata", "ModelingMetadata", "ParametersOfInterestMetadata", "RiskMetadata",
    ),
    "https://www.omg.org/spec/SysML/20250201/Quantities-and-Units-Domain-Library.kpar": (
        "ISQ", "ISQAcoustics", "ISQAtomicNuclear", "ISQBase", "ISQCharacteristicNumbers",
        "ISQChemistryMolecular", "ISQCondensedMatter", "ISQElectromagnetism", "ISQInformation",
        "ISQLight", "ISQMechanics", "ISQSpaceTime", "ISQThermodynamics",
        "MeasurementRefCalculations", "MeasurementReferences", "Quantities",
        "QuantityCalculations", "SI", "SIPrefixes", "TensorCalculations", "Time", "USCU",
        "USCustomaryUnits", "VectorCalculations",
    ),
    "https://www.omg.org/spec/SysML/20250201/Requirement-Derivation-Domain-Library.kpar": (
        "DerivationConnections", "RequirementDerivation",
    ),
}  # fmt: skip
OMG_ROOTS = {root: iri for iri, roots in OMG_ARCHIVES.items() for root in roots}

PACKAGE_RE = re.compile(r"^(?:standard\s+)?library\s+package\s+([A-Za-z_][A-Za-z0-9_]*)", re.M)
COMMENT_OR_STRING_RE = re.compile(r"/\*.*?\*/|//[^\n]*|\"(?:[^\"\\]|\\.)*\"|'(?:[^'\\]|\\.)*'", re.S)
IMPORT_RE = re.compile(r"\bimport\s+(?:all\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*::")
QUALIFIED_RE = re.compile(r"(?<![A-Za-z0-9_:])([A-Za-z_][A-Za-z0-9_]*)\s*::")


class Failure(Exception):
    pass


def repo_root() -> Path:
    return Path(__file__).resolve().parent.parent


def unit_paths(root: Path) -> list:
    libraries = root / LIBRARIES_DIR
    paths = sorted(p for p in libraries.iterdir() if p.is_file() and p.suffix in UNIT_SUFFIXES)
    if not paths:
        raise Failure(f"{libraries} holds no .sysml or .kerml file")
    return paths


def root_package(path: Path, text: str) -> str:
    match = PACKAGE_RE.search(text)
    if not match:
        raise Failure(f"{path.name} declares no top-level library package")
    return match.group(1)


def referenced_roots(text: str) -> tuple:
    """The root namespaces a unit's imports name, and the names qualified references begin with."""
    code = COMMENT_OR_STRING_RE.sub(" ", text)
    return set(IMPORT_RE.findall(code)), set(QUALIFIED_RE.findall(code))


def derive_usage(texts: dict, roots: dict) -> list:
    """The OMG archives declaring a root namespace the units depend on and none here declares.

    An import root must be a library here or an OMG root. A qualified reference
    counts when its first name is an OMG root (CONTRIBUTING forbids reusing one);
    any other first name is a member declared somewhere in the unit itself.
    """
    own = set(roots.values())
    archives = set()
    for path, text in texts.items():
        imported, qualified = referenced_roots(text)
        for root in sorted(imported - own):
            iri = OMG_ROOTS.get(root)
            if iri is None:
                raise Failure(f"{path}: imports {root}, which no library here or OMG standard-library archive declares")
            archives.add(iri)
        for root in sorted(qualified - own):
            if root in OMG_ROOTS:
                archives.add(OMG_ROOTS[root])
    return [{"resource": iri} for iri in sorted(archives)]


def load_json(path: Path) -> dict:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise Failure(f"{path.name} is missing; a tree without it is not a project") from None
    except json.JSONDecodeError as err:
        raise Failure(f"{path.name}: {err}") from None
    if not isinstance(data, dict):
        raise Failure(f"{path.name} does not hold a JSON object")
    return data


def check_project(root: Path, texts: dict, roots: dict) -> dict:
    project = load_json(root / PROJECT_FILE)
    for field in REQUIRED_FIELDS:
        if field not in project or project[field] in ("", None, []):
            raise Failure(f"{PROJECT_FILE}: field {field!r} is missing or empty")
    for field in REQUIRED_FIELDS[:-1]:
        if not isinstance(project[field], str):
            raise Failure(f"{PROJECT_FILE}: field {field!r} must be a string")
    if project["publisher"] != EXPECTED_PUBLISHER:
        raise Failure(f"{PROJECT_FILE}: publisher is {project['publisher']!r}, expected {EXPECTED_PUBLISHER!r}")
    if not SEMVER_RE.match(project["version"]):
        raise Failure(f"{PROJECT_FILE}: version {project['version']!r} is not a semantic version")
    if not isinstance(project["usage"], list) or any(
        not isinstance(u, dict) or not isinstance(u.get("resource"), str) for u in project["usage"]
    ):
        raise Failure(f"{PROJECT_FILE}: usage must be a list of objects with a string resource")
    derived = derive_usage(texts, roots)
    derived_iris = [u["resource"] for u in derived]
    written = [u["resource"] for u in project["usage"]]
    if written != derived_iris:
        missing = sorted(set(derived_iris) - set(written))
        extra = sorted(set(written) - set(derived_iris))
        detail = []
        if missing:
            detail.append("missing: " + ", ".join(missing))
        if extra:
            detail.append("not used by any unit: " + ", ".join(extra))
        if not detail:
            detail.append("the entries must be sorted by resource")
        raise Failure(f"{PROJECT_FILE}: usage does not match the imports under {LIBRARIES_DIR}/ ({'; '.join(detail)})")
    return project


def sha256(data: bytes) -> dict:
    return {"algorithm": "SHA256", "value": hashlib.sha256(data).hexdigest()}


def created_time() -> str:
    epoch = os.environ.get("SOURCE_DATE_EPOCH")
    when = datetime.fromtimestamp(int(epoch), timezone.utc) if epoch else datetime.now(timezone.utc)
    return when.strftime("%Y-%m-%dT%H:%M:%SZ")


def build_meta(root: Path, paths: list, created: str) -> dict:
    index = {}
    checksum = {}
    metamodel = METAMODEL_KERML
    for path in paths:
        data = path.read_bytes()
        member = path.relative_to(root).as_posix()
        package = root_package(path, data.decode("utf-8"))
        if package in index:
            raise Failure(f"{member} and {index[package]} both declare {package}; a project's namespace is flat")
        if package != path.stem:
            raise Failure(f"{member} declares {package}; the file stem must equal the package name")
        index[package] = member
        checksum[member] = sha256(data)
        if path.suffix == ".sysml":
            metamodel = METAMODEL_SYSML
    license_path = root / LICENSE_FILE
    if not license_path.is_file():
        raise Failure(f"{LICENSE_FILE} is missing; the project ships its license")
    checksum[LICENSE_FILE] = sha256(license_path.read_bytes())
    return {
        "index": dict(sorted(index.items())),
        "created": created,
        "metamodel": metamodel,
        "checksum": dict(sorted(checksum.items())),
    }


def render(meta: dict) -> str:
    return json.dumps(meta, indent=2, sort_keys=True) + "\n"


def check_meta(root: Path, want: dict) -> dict:
    have = load_json(root / META_FILE)
    created = have.get("created")
    if not isinstance(created, str):
        raise Failure(f"{META_FILE}: the created time is missing")
    try:
        datetime.strptime(created, "%Y-%m-%dT%H:%M:%SZ")
    except ValueError:
        raise Failure(f"{META_FILE}: created {created!r} is not an ISO 8601 UTC time (YYYY-MM-DDTHH:MM:SSZ)") from None
    want = dict(want, created=created)
    if have != want:
        for field in ("index", "metamodel", "checksum"):
            if have.get(field) != want[field]:
                raise Failure(f"{META_FILE}: {field} does not match the tree; run scripts/write-project-meta.py")
        raise Failure(f"{META_FILE}: holds fields beyond index, created, metamodel and checksum")
    if (root / META_FILE).read_text(encoding="utf-8") != render(have):
        raise Failure(f"{META_FILE}: not in the canonical form; run scripts/write-project-meta.py")
    return have


def check_tree(root: Path) -> tuple:
    """Verify the committed manifests against the tree; return (project, meta)."""
    paths = unit_paths(root)
    texts = {p.relative_to(root).as_posix(): p.read_text(encoding="utf-8") for p in paths}
    roots = {member: root_package(root / member, text) for member, text in texts.items()}
    project = check_project(root, texts, roots)
    meta = check_meta(root, build_meta(root, paths, created_time()))
    return project, meta


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--check", action="store_true", help="verify the committed manifests instead of writing .meta.json")
    args = parser.parse_args()
    root = repo_root()
    try:
        if args.check:
            project, meta = check_tree(root)
            print(f"{PROJECT_FILE} and {META_FILE} match the tree ({project['name']} {project['version']}, {len(meta['index'])} units)")
        else:
            paths = unit_paths(root)
            texts = {p.relative_to(root).as_posix(): p.read_text(encoding="utf-8") for p in paths}
            roots = {member: root_package(root / member, text) for member, text in texts.items()}
            project = check_project(root, texts, roots)
            meta = build_meta(root, paths, created_time())
            (root / META_FILE).write_text(render(meta), encoding="utf-8")
            print(f"Wrote {META_FILE} ({project['name']} {project['version']}, {len(paths)} units)")
    except Failure as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
