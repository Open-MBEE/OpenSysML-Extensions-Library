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
| RandomFunctions | RandomFunctions.kerml | Seeded random draws: uniform, uniformInteger, triangular, normal. | Executing engine |
| Simulation | Simulation.sysml | How a behavior is meant to be run: run count, draw resolution, clock, Monte Carlo. | Executing engine |
| StateMachines | StateMachines.sysml | Pseudostates (choice, junction, shallow/deep history) the grammar has no production for. | Executing engine |
| StateSpaceIntegration | StateSpaceIntegration.sysml | Fixed-step (Euler/RK4) running of StateSpaceRepresentation dynamics. | Executing engine |
| Stochastic | Stochastic.sysml | Probability metadata for branches; a tool unaware of it runs the branches as an unweighted choice. | Executing engine |
| SysMLValidation | SysMLValidation.sysml | KerML/SysML abstract-syntax validation constraints over the reflective metamodel. | Executing engine |

Portability "Executing engine" means an executing engine gives the library its
behavior; the libraries still parse and resolve in any tool — only their
behavior needs an engine.

## Layout

`libraries/` is flat: one `library package` per file, and the file stem equals
the package name. SysML resolves libraries by package name, not path, so any
tool can load the directory as-is. The folder these files used to live in,
`OpenSysML Libraries/`, was OpenSysML's library-tier folder; the history here
was imported from Open-MBEE/OpenSysML, and old `#N` references in commit
messages point at that repository.

## Using the libraries

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
  `scripts/sync-extension-libraries.sh`. Edits land here first.

## Versioning

Releases are semver tags `vX.Y.Z` on `main`:

- **MAJOR** — removing or renaming a library or a public element, or changing
  its meaning.
- **MINOR** — adding a library or element.
- **PATCH** — documentation and doc-comment changes and fixes that keep names
  and meaning.

Each release attaches a `.kpar` project archive. Consumers pin a tag or
commit.

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
warnings. Four warnings are temporarily allow-listed in
`validation/allowed-warnings.txt` — the four files that still declare
`standard library package`; an upstream change to `library package` is being
ported and those entries will be deleted. The allow-list only shrinks.

## License

Apache-2.0. Every library was authored in OpenSysML; no OMG material is
redistributed here.
