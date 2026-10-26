# OpenSysML Extension Libraries

A community repository of **non-normative** SysML v2 / KerML extension
libraries. They are maintained here and consumed by
[OpenSysML](https://github.com/Open-MBEE/OpenSysML) and any other SysML v2
tool. They are **not** part of the OMG standard library; some of them are
proposed for standardization (DiagramLayout, IdentityMetadata and
MigrationMetadata say so in their doc text).

A model that uses one of these libraries is valid SysML v2 that depends on a
non-normative OpenSysML library; other tools resolve it when given the
`libraries/` folder (OpenSysML bundles the same files as its
`OpenSysML Libraries` folder).

## The libraries

| Library | File | Description | Portability |
|---|---|---|---|
| AnalysisRecords | AnalysisRecords.sysml | Metadata a run, sweep or sample records itself with: when it ran, the tool and command, verdicts and evaluations. | Executing engine |
| DiagramLayout | DiagramLayout.sysml | Diagram geometry: element placement, edge waypoints and the drawing extent. | Any SysML v2 tool |
| DocumentQueries | DocumentQueries.sysml | Calc definitions (OwnedElements, Descendants, Ancestors, …) that document views evaluate to select elements. | Executing engine |
| IdentityMetadata | IdentityMetadata.sysml | Binds notation to repository element identity. | Any SysML v2 tool |
| MOSA | MOSA.sysml | Modular Open Systems Approach (10 U.S.C. § 4401) vocabulary. | Any SysML v2 tool |
| MigrationMetadata | MigrationMetadata.sysml | What a migration from another modelling language had to make up because the source left it unstated. | Any SysML v2 tool |
| OOSEM | OOSEM.sysml | Object-Oriented Systems Engineering Method artefacts, viewpoints and product views. | Any SysML v2 tool |
| OpenSysMLMathFunctions | OpenSysMLMathFunctions.kerml | exp, ln, log, atan2, ceiling and the Integer quotient the Kernel Function Library omits. | Executing engine |
| OpenSysMLRenderings | OpenSysMLRenderings.sysml | Renderings and views for case and mixed diagrams. `CaseView`/`asCaseDiagram` is a shorter way to write a standard `GeneralView` filtered on case-family metaclasses; the standard route is added by [OpenSysML#886](https://github.com/Open-MBEE/OpenSysML/pull/886). `MixedView`/`asMixedDiagram` is extension-only. | Any SysML v2 tool |
| RandomFunctions | RandomFunctions.kerml | Seeded random draws: uniform, uniformInteger, triangular, normal. | Executing engine |
| Simulation | Simulation.sysml | How a behavior is meant to be run: run count, draw resolution, clock, Monte Carlo. | Executing engine |
| StateActivity | StateActivity.kerml | `isActive`: a derived Boolean that is true while a state usage is in its state machine's active configuration. | Executing engine |
| StateMachines | StateMachines.sysml | Pseudostates (choice, junction, shallow/deep history) the grammar has no production for. | Executing engine |
| StateSpaceIntegration | StateSpaceIntegration.sysml | Fixed-step (Euler/RK4) running of StateSpaceRepresentation dynamics. | Executing engine |
| Stochastic | Stochastic.sysml | Probability metadata for branches; a tool unaware of it runs the branches as an unweighted choice. | Executing engine |
| SysMLValidation | SysMLValidation.sysml | KerML/SysML abstract-syntax validation constraints over the reflective metamodel. | Executing engine |

Portability "Executing engine" means an executing engine gives the library its
behavior; the libraries still parse and resolve in any tool — only their
behavior needs an engine.

## Layout

The repository is a KerML 10.3 project interchange: `.project.json` at the
root names the project (`OpenSysML Extensions Library`, publisher `Open-MBEE`,
its `version`, and the OMG standard-library archives the units use) and
`.meta.json` indexes the root namespace each unit declares with a SHA-256
checksum per file, both in the OMG format any SysML v2 tool reads. A tagged
commit of the tree *is* the project; the release `.kpar` is the same files
archived. `./scripts/write-project-meta.py --check` fails in CI when either
manifest drifts from the tree.

`libraries/` is flat: one `library package` per file, and the file stem equals
the package name. SysML resolves libraries by package name, not path, so any
tool can load the directory as-is. The folder these files used to live in,
`OpenSysML Libraries/`, was OpenSysML's library-tier folder; the history here
was imported from Open-MBEE/OpenSysML, and old `#N` references in commit
messages point at that repository.

## Using the libraries

### As a package

A project depends on this library by naming the repository and a tag in its
own `.project.json` (KerML 1.0 §10.3, Table 12):

```json
{
  "name": "MyModel",
  "version": "0.1.0",
  "usage": [
    {"resource": "pkg:git/github.com/Open-MBEE/OpenSysML-Extensions-Library", "versionConstraint": "1.0.0"}
  ]
}
```

The IRI is `pkg:git/<host>/<path>`, optionally `@<version>`; a plain clone
URL with `@<version>` is accepted by package managers and normalised to it. A
package manager installs the repository tree at tag `v1.0.0` (or the release's
`.kpar`, which holds the same files) into the project's library directory,
`lib/` beside `.project.json`, and the tool resolves `import DiagramLayout::*`
from there; the tool itself never fetches. The `usage` entries of this library's own
`.project.json` name the OMG archives
(`https://www.omg.org/spec/KerML/20250201/<Library>.kpar`,
`https://www.omg.org/spec/SysML/20250201/<Library>.kpar`) its units import,
so a manager installs the standard library the same way.

### Per tool

Every tool also needs the OMG standard library (`sysml.library`).

- **OMG pilot batch validator** —
  `validate-sysml-batch --library <sysml.library> libraries <your model dir>`
  (`validate-sysml --library DIR [--root DIR] FILE|DIR...`). The validator in
  this repository (`./scripts/download-pilot-sysml-validator.sh`) builds the
  same program.
- **Pilot Eclipse** — import this repository into the workspace as a project
  alongside `sysml.library`, so the editor indexes it the same way.
- **SysON** — import the `.sysml` files into the project, or into a library
  project it references if your SysON version supports that; see SysON's
  documentation. SysON does not execute behavior, so the portable libraries
  are the ones that matter there.
- **sysml-toolkit** —
  `sysmlv2 check --lib <sysml.library> libraries/*.sysml libraries/*.kerml model.sysml`,
  or pass the release `.kpar` (the CLI expands `.kpar` inputs).
- **OpenSysML** — bundled: it vendors a pinned copy at
  `internal/workspace/libs/stdlib/OpenSysML Libraries/`, pinned by
  `scripts/extension-libraries-pin.sh` and refreshed by
  `scripts/sync-extension-libraries.sh`. Edits land here first. A newer
  revision than the bundled one is read as a project: name the release `.kpar`
  beside the model (`sysml -validate model.sysml opensysml-extensions-library-1.0.0.kpar`),
  or install the tag's tree or the `.kpar` under `lib/` beside the model's
  `.project.json`, which names it as
  `pkg:git/github.com/Open-MBEE/OpenSysML-Extensions-Library` (`sysml -validate <project>`).

## Versioning

Releases are semver tags `vX.Y.Z` on `main`:

- **MAJOR** — removing or renaming a library or a public element, or changing
  its meaning.
- **MINOR** — adding a library or element.
- **PATCH** — documentation and doc-comment changes and fixes that keep names
  and meaning.

The tag equals `.project.json`'s `version`: a release-prep commit bumps the
`version` field (and nothing else need change — `.meta.json` carries no
version), then the maintainer tags `vX.Y.Z` on that commit. The release
workflow refuses a tag that does not equal the committed `version`, re-checks
the manifests against the tree, builds
`opensysml-extensions-library-X.Y.Z.kpar` with `./scripts/build-kpar.py
--version X.Y.Z` and attaches it to the GitHub release. The archive is derived
from the tag's tree and its two manifests, so the tree a package manager
installs from GitHub and the `.kpar` are one project; the build is
byte-deterministic (sorted entries, deflate, 1980-01-01 dates). Consumers pin
a tag through `versionConstraint`.

## Engine contract

`engine-contract.json` lists the qualified names in `libraries/` that
OpenSysML's engine binds to — the functions its runtime registry implements,
the metadata and features it reads, the DocumentQueries elements its document
and query plans compile, and the names the SysML v1 migrator writes into user
models. OpenSysML binds by qualified name, so those names are an API: removing,
renaming or changing an entry is a breaking change and needs `contract`
bumped, a coordinated Open-MBEE/OpenSysML pull request that re-pins its
vendored copy, and a MAJOR release. Additions are MINOR.

`./scripts/check-engine-contract.sh` validates the manifest and resolves every
entry against `libraries/` on the pinned pilot; in pull requests it also diffs
the manifest against the base and fails on unannounced breaking changes.

## Validation

`./scripts/validate-libraries.sh` runs the pinned OMG pilot batch validator
(`scripts/pilot-pin.sh`) over `libraries/` and requires zero errors and zero
warnings. `validation/allowed-warnings.txt` is empty: no warning is
allow-listed, and the ratchet fails on any allow-list entry the validator no
longer emits.

## License

Apache-2.0. Every library was authored in OpenSysML; no OMG material is
redistributed here.
