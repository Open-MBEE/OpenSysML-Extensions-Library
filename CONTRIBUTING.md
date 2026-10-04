# Contributing

## Proposing a library

Open an issue or pull request stating the library's purpose, its intended
consumers, and its portability (any SysML v2 tool, or an executing engine).

## Naming

- UpperCamelCase; the package name equals the file stem.
- One top-level `library package` per file.
- Never reuse an OMG standard-library package name.
- `.kerml` only for KerML-only content; everything else is `.sysml`.

## Documentation

- A top-level `doc` that says NON-NORMATIVE and what the library is for.
- Every public definition documented.

## Validation

- `./scripts/validate-libraries.sh` must pass on the pinned pilot with 0
  errors and 0 warnings.
- `validation/allowed-warnings.txt` only shrinks: never add an entry.
- Never write `standard library package` — that keyword is reserved for the
  OMG standard library and the pilot validator warns on it.
- A README table row is required; CI checks the table against `libraries/`.
- State the semver impact of your change in the pull request (see Versioning
  in the README).

## Review

At least one maintainer approval. Changes OpenSysML's runtime depends on need
a matching OpenSysML pull request that re-pins its vendored copy; edits to
that vendored copy are not accepted in OpenSysML — they come here.

## Bumping the pilot pin

Edit `scripts/pilot-pin.sh` (`PILOT_TAG` and `PILOT_COMMIT` together) and
re-run `./scripts/verify-pilot-pin.sh` and `./scripts/validate-libraries.sh`.
