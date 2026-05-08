# Changelog

All notable changes to **userflow** are documented here. Versions follow **Semantic Versioning** (`MAJOR.MINOR.PATCH`). The **build number** increments with each merged ticket (MT-01 → build 1, MT-02 → build 2, etc.) unless the release policy changes. **New builds are appended at the top of their marketing version section** — previous build notes stay.

## [1.0.0] — 2026-05-07

**Marketing version:** `1.0.0`

### Build 6 — MT-06 Coordinators _(latest entry)_

**Binary build:** `6`

#### Added

- **`UsersFlowCoordinator`** (`ObservableObject`): inyección **`UserRepository`** (**`DefaultUserRepository`** + **`JSONPlaceholderUsersClient`** por defecto en **`ContentView`**); estado de navegación (`detailLocalId`, `isPresentingCreateUser`).
- **`UsersFlowRootView`**: **`NavigationView`** + **`StackNavigationViewStyle`** (**iOS 15**); toolbar **`+`** para sheet de alta (**`MT-10`**); textos en **String Catalog** ES/EN.
- **Host placeholders**: **`UsersListCoordinatorHostView`**, **`UsersDetailCoordinatorHostView`**, **`UsersCreateCoordinatorHostView`** (navegación programada con **`NavigationLink(isActive:)`** hacia detalle de ejemplo `remote-1`).

#### Changed

- **`ContentView`**: raíz = **`usersCoordinator.rootView()`** en lugar del placeholder global.
- **`AppCoordinating`**: doc alineada con **`UsersFlowCoordinator`** (**`MT-06`**).
- **`Localizable.xcstrings`**: claves `users.coordinator.*`, **`users.create.navigationTitle`**, **`users.detail.navigationTitle`**.
- Eliminados **`Users*ModuleMarker.swift`** sustituidos por vistas reales de host.
- **`CURRENT_PROJECT_VERSION`** → **`6`** (Debug/Release).

---

### Build 5 — MT-05 Repository merge

**Binary build:** `5`

#### Added

- **`UserRepository`** / **`DefaultUserRepository`**: composes **`UsersRemoteServicing`** + Realm; **`refreshRemoteUsers()`** upserts by **`remote-{apiId}`** via **`applyRemoteSnapshot`** (**`isDeleted`** untouched — tombstones survive refetch **MT-11**).
- **`listUsersForDisplay()`**: excludes **`isDeleted`**, honors **`editedName`** / **`editedEmail`**, sort by **`displayName`** then **`localId`**.
- **`UserListItem`**: **`Sendable`** list projection for **`MT-07`**.
- **`UserObject` local convenience init** (**`MT-10`** path): **`apiId == 0`**, UUID **`localId`**, **`createLocalUser(...)`**.
- **`setEditedName`** / **`setEditedEmail`** for local overrides (**`MT-08`**); **`UserRepositoryError.userNotFound`**.

#### Changed

- **`CURRENT_PROJECT_VERSION`** → **`5`** (Debug/Release).

---

### Build 4 — MT-04 Realm schemas

**Binary build:** `4`

#### Added

- **`UserObject`** (`RealmSwift`): PK `localId`, indexed **`apiId`**, **`isDeleted`** (logical delete tombstone), `isLocallyCreated`, remote snapshot fields (name/username/email/phone/website/address/geo/company) and optional **`editedName` / `editedEmail`** for local overrides (**`MT-08`**).
- **`UserPrimaryKey`**: deterministic `remote-{apiId}` vs UUID for local-only rows (**`MT-05`** upserts).
- **`UserObject` + `UserDTO`**: `applyRemoteSnapshot` / convenience init inside write transactions (**`MT-05`** merge).
- **`RealmBootstrap.configureDefault()`**: **`schemaVersion: 1`** with migration scaffold (fresh install **`MT-04`**).

#### Changed

- App launch calls **`RealmBootstrap.configureDefault()`** before touching the default Realm file URL.
- `CURRENT_PROJECT_VERSION` → **`4`** (Debug/Release).

---

### Build 3 — MT-03 Networking

**Binary build:** `3`

#### Added

- **`UserDTO`** (+ `AddressDTO`, `GeoDTO`, `CompanyDTO`) mapping JSONPlaceholder `GET /users` (incl. nested `address.city` for UI later).
- **`JSONPlaceholderConfiguration`** base URL and `/users` helpers.
- **`NetworkingError`** (`invalidHTTPStatus`, `decoding`, `transport`) with `asAppError()` bridge to `AppError`.
- **`UsersRemoteServicing`** protocol and **`JSONPlaceholderUsersClient`**: `fetchUsers()` and `deleteUser(id:)` via **Alamofire** `async`/`await` (`serializingDecodable` / `serializingData`), `200..<300` validation.
- **`nonisolated` `Decodable`** on DTO extensions for compatibility with **`Sendable`** + default **MainActor** isolation in the target.

#### Changed

- `CURRENT_PROJECT_VERSION` → **`3`** (Debug/Release).

---

### Build 2 — MT-02 Foundations

**Binary build:** `2`

#### Added

- MVVM+C folder scaffold under `userflow/` → `App/`, `Core/` (Networking, Persistence, Validation, Location), `Features/Users/{List,Detail,Create}`, `Coordinators/`, `Resources/`.
- `Resources/Localizable.xcstrings` with **en + es** (app name, users title, `AppError` messages, **Cancel/OK**, location copy placeholder for MT-12).
- `AppError` + `AppCoordinating` protocol shell; module marker files for upcoming tickets.
- `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` (English) for future creation flow.
- Alamofire dependency exercised via `Session.default` in `App/userflowApp.swift` (alongside existing Realm touch).
- Project `knownRegions` includes **`es`**.
- Draft PR description: `docs/tickets/MT-02-pull-request-description.md`.

#### Changed

- `CURRENT_PROJECT_VERSION` set to **`2`** (Debug/Release).

---

### Build 1 — MT-01 Bootstrap

**Binary build:** `1`

#### Added

- Root `.gitignore` for Xcode, Swift, and Swift Package Manager artefacts.
- `docs/development-plan.md`: Jira-style MT ticket breakdown and technical scope.
- `docs/templates/pull_request_template.md`: uniform PR description template (mirrored under `.github/pull_request_template.md` for GitHub).
- App bootstrap verification: `RealmSwift` import and touch of default Realm configuration so the SPM-linked binary is exercised.

#### Changed

- **iOS minimum deployment target:** `15.0` for project and app target (`IPHONEOS_DEPLOYMENT_TARGET`).
- Swift package lockfile `Package.resolved` committed for reproducible SPM resolution.
- Documentation layout under **`docs/`**: `development-plan.md`, **`templates/`** (canonical PR template), **`tickets/`** (PR drafts); root **`README.md`** summarizes doc paths; **`doc/`** retired to avoid duplication.
