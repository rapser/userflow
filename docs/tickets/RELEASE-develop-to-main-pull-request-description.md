# Release — Pull request `develop` → `main`

**Title (GitHub):**

```
[Release 1.0.0] userflow — alcance técnico completo (MT-01…MT-13, build 13)
```

**Compare:**

https://github.com/rapser/userflow/compare/main...develop?expand=1

---

## Descripción

PR de integración que promueve a `main` la versión **1.0.0** (build **13**) de **userflow**, con el **100 % del alcance técnico obligatorio** cubierto a través de los tickets **MT-01 … MT-13**.

La app iOS (**SwiftUI, MVVM + Coordinator, Realm, Alamofire, async/await, iOS 15+, ES/EN**) obtiene usuarios desde [JSONPlaceholder](https://jsonplaceholder.typicode.com/users), los fusiona con persistencia local Realm, y expone lista, detalle con edición, alta de usuario, borrado lógico y captura de ubicación puntual.

---

## Tickets incluidos

| Ticket | Título | Build |
|--------|--------|-------|
| **MT-01** | Bootstrap: `.gitignore`, iOS 15 mínimo, verificar SPM Realm | `1` |
| **MT-02** | Foundations: estructura, Alamofire verificado, i18n base | `2` |
| **MT-03** | Networking JSONPlaceholder + errores | `3` |
| **MT-04** | Modelos Realm y borrado lógico | `4` |
| **MT-05** | Repository merge: API + Realm + filtros | `5` |
| **MT-06** | Coordinators (MVVM + C) | `6` |
| **MT-07** | Lista principal de usuarios (JSON/API + Realm) | `7` |
| **MT-08** | Pantalla Detalle | `8` |
| **MT-09** | Validaciones reutilizables | `9` |
| **MT-10** | Alta de usuario (formulario local) | `10` |
| **MT-11** | Eliminar: simulación API + persistencia + lista | `11` |
| **MT-12** | Core Location When In Use + botón crear | `12` |
| **MT-13** | README + plan en repo + fixes concurrencia Realm | `13` |

---

## Resumen de cambios por área

### Stack y proyecto (MT-01, MT-02)
- `.gitignore` Xcode/SPM; `IPHONEOS_DEPLOYMENT_TARGET = 15.0`.
- Estructura `App/`, `Core/`, `Features/Users/{List,Detail,Create}`, `Coordinators/`, `Resources/`.
- `Localizable.xcstrings` con localizaciones **ES / EN** completas.
- `AppError`, `AppCoordinating`, `AppDiagnostics`, `AppForegroundTask`.

### Networking (MT-03)
- `UserDTO` + DTOs anidados (`AddressDTO`, `GeoDTO`, `CompanyDTO`) mapeando `GET /users`.
- `JSONPlaceholderUsersClient`: `fetchUsers()` y `deleteUser(id:)` con **Alamofire async/await**.
- `NetworkingError` con puente a `AppError`.

### Persistencia Realm (MT-04, MT-05)
- `UserObject`: PK `localId`, `apiId` indexado, `isDeleted` (tombstone), `editedName`/`editedEmail`, snapshot remoto.
- `UserPrimaryKey`: clave determinista `remote-{apiId}` vs. UUID para usuarios locales.
- `RealmBootstrap`: `schemaVersion: 1` con scaffold de migración.
- `DefaultUserRepository`: `refreshRemoteUsers()` (upsert sin pisar `isDeleted`), `listUsersForDisplay()` (filtra tombstones, honra overrides locales), `createLocalUser`, `setLocalDisplayEdits`, `deleteUser`.
- `RealmRemoteMergeSupport`: merge fuera de `MainActor` para no bloquear UI.

### Coordinadores y navegación (MT-06)
- `UsersFlowCoordinator` + `UsersFlowRootView`: `NavigationView` + `StackNavigationViewStyle` (iOS 15), toolbar `+`, sheet de alta.

### Lista de usuarios (MT-07)
- `UsersListViewModel`: carga inicial, `refreshRemoteUsers`, `.searchable` con filtro cacheado, aviso red, `reloadFromCache` tras alta o cierre de detalle.
- `UserListCardRow`: tarjeta agrupada (nombre, username, ciudad, teléfono, email, avatar SF Symbol).
- `UsersListCoordinatorHostView`: fondo `secondarySystemGroupedBackground`, `refreshable`, `NavigationLink` iOS 15, **recarga automática al volver del detalle**.

### Detalle y edición (MT-08, MT-09)
- `UserDetailSnapshot` + `UsersDetailViewModel`: carga, modo edición, `saveEdits` con validación email.
- `UsersDetailCoordinatorHostView`: hero avatar, campos completos, links `tel:`/`mailto:`/`http:`, agrupación tipo lista.
- `UserFormValidators` / `UserFormValidationFailure`: validación de texto obligatorio (trim), email y teléfono; reutilizados en alta y detalle.

### Alta de usuario (MT-10)
- `UsersCreateViewModel` + `UsersCreateCoordinatorHostView`: formulario con secciones, toolbar Guardar (iOS 15), validación MT-09, banner de error.

### Borrado lógico (MT-11)
- `deleteUser(localId:)`: `DELETE /users/:id` cuando `apiId > 0`; tombstone `isDeleted = true`; `listUsersForDisplay()` excluye tombstones.
- Botón Eliminar en detalle con confirmación y cierre automático de navegación.

### Core Location (MT-12)
- `CreationLocationController`: permiso **When In Use**, `requestLocation()` al pulsar botón, sheet con lat/long formateadas, mensajes de denegado/error.
- `NSLocationWhenInUseUsageDescription` en `InfoPlist.strings` **en** y **es**.

### Documentación y fixes (MT-13)
- `README.md` exhaustivo: tabla requisitos → implementación, arquitectura MVVM+C, política merge/`isDeleted`, i18n, ubicación, ejecución y versión.
- `development-plan.md` alineado con README.
- Fixes de concurrencia Realm (merge en hilo separado, locks, `AppForegroundTask.executeSafe`).

---

## Checklist

- [x] `IPHONEOS_DEPLOYMENT_TARGET = 15.0`
- [x] Compila sin errores ni warnings bloqueantes
- [x] Lista carga desde `GET /users` + merge Realm (tombstones persistentes)
- [x] Detalle muestra todos los campos; edición nombre/email persiste y **se refleja en lista al volver**
- [x] Alta local persiste y aparece en lista
- [x] Borrado lógico: usuario desaparece de lista y no reaparece tras refetch remoto
- [x] Ubicación: permiso When In Use, sheet con coordenadas al pulsar botón en alta
- [x] Validadores reutilizables (vacío, email, teléfono) integrados en alta y detalle
- [x] i18n ES/EN: textos UI, errores, permisos de ubicación
- [x] `CHANGELOG.md` con builds 1–13; `CURRENT_PROJECT_VERSION = 13`
- [x] `README.md` exhaustivo y alineado con implementación
- [x] Sin `UIBackgroundModes` de localización; sin tabs en navegación

---

## Información de versión

| Campo | Valor |
|-------|-------|
| Marketing version | `1.0.0` |
| `CURRENT_PROJECT_VERSION` | `13` |
| Rama origen | `develop` |
| Rama destino | `main` |
