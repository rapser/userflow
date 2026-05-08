# Changelog

All notable changes to **userflow** are documented here. Versions follow **Semantic Versioning** (`MAJOR.MINOR.PATCH`). The **build number** increments with each merged ticket (MT-01 → build 1, MT-02 → build 2, etc.) unless the release policy changes.

## [1.0.0] — 2026-05-07

**Marketing version:** `1.0.0`  
**Build:** `1` (MT-01)

### Added

- Root `.gitignore` for Xcode, Swift, and Swift Package Manager artefacts.
- `docs/development-plan.md`: Jira-style MT ticket breakdown and technical scope.
- `docs/templates/pull_request_template.md`: uniform PR description template (mirrored under `.github/pull_request_template.md` for GitHub).
- App bootstrap verification: `RealmSwift` import and touch of default Realm configuration so the SPM-linked binary is exercised.

### Changed

- **iOS minimum deployment target:** `15.0` for project and app target (`IPHONEOS_DEPLOYMENT_TARGET`).
- Swift package lockfile `Package.resolved` committed for reproducible SPM resolution.
- Documentation layout under **`docs/`**: `development-plan.md`, **`templates/`** (canonical PR template), **`tickets/`** (PR drafts); root **`README.md`** summarizes doc paths; **`doc/`** retired to avoid duplication.
