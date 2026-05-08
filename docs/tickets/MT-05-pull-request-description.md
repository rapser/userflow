# MT-05 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-05] Repository: merge GET /users + Realm, filtros lista y alta/edición local
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-05-repository-merge?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-05 (Repository merge)** del plan (`docs/development-plan.md`): añade **`UserRepository`** / **`DefaultUserRepository`** (`@MainActor`) como único punto que compone **`UsersRemoteServicing`** + Realm según la **política de merge** del plan.

- **`refreshRemoteUsers()`**: `GET /users`, upsert por **`UserPrimaryKey.forRemoteUser(apiId)`** vía **`UserObject.applyRemoteSnapshot`** (**no reescribe `isDeleted`** — tombstones listos para **`MT-11`**).
- **`listUsersForDisplay()`**: excluye filas con **`isDeleted == true`**, proyecta **`UserListItem`** con **`editedName` / `editedEmail`** cuando apliquen (**`MT-08`**), orden estable por **`displayName`** y **`localId`** (**`MT-07`** consume este modelo **`Sendable`**).
- **`createLocalUser`** + init local en **`UserObject+LocalWrites`** (**`apiId == 0`**, UUID **`localId`**) como base para **`MT-10`**.
- **`setEditedName`** / **`setEditedEmail`** (tras trim; **`nil`** limpia override); **`UserRepositoryError.userNotFound`**.

**Versión marketing** `1.0.0`, **build binario `5`**. **`CHANGELOG`**: **`### Build 5 — MT-05 Repository merge`** arriba del resto.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-05 — Repository merge: API + Realm + filtros |
| Rama | `feature/MT-05-repository-merge` |
| Base | `develop` |
| **Jira** | [UFLOW-105](https://acme-payments.atlassian.net/browse/UFLOW-105) _(instancia / clave de ejemplo; convención `UFLOW-10N` ↔ MT-0N — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `5` |

Registro de cambios: **`CHANGELOG.md`** → **`## [1.0.0]`**; bloque superior **`### Build 5 — MT-05 Repository merge`**.

---

## Cambios realizados

- **`UserListItem`** + orden **`sortForList`**.
- **`UserObject`**: conveniencia **`localOnlyName:…`** (**`UserObject+LocalWrites.swift`**).
- **`UserRepository`**, **`DefaultUserRepository`**, **`UserRepositoryError`**.
- **`CURRENT_PROJECT_VERSION = 5`**; **CHANGELOG** Build 5 documentado.

---

## Git / historial de la rama

Tres commits sobre `develop`:

1. `feat(MT-05): add user repository merge and list projection` (`3ddff6a`)
2. `chore(project): CHANGELOG build 5; bump CURRENT_PROJECT_VERSION` (`da4af03`)
3. `docs: add MT-05 pull request description draft`

*(Los hashes corresponden a la rama publicada; cambian si se reescribe historial.)*

---

## Capturas (solo si aplica)

**N/A** — sin pantallas nuevas; la lista en SwiftUI llega en **`MT-07`**.

---

## Cómo probarlo

1. Abrir **`userflow.xcodeproj`**, destino **iOS 15+**.
2. **Product → Build** (`⌘B`).
3. **General → Identity**: **Versión `1.0.0`**, **Build `5`**.
4. _(Opcional)_ En el depurador o un test puntual: instanciar **`DefaultUserRepository(remote: JSONPlaceholderUsersClient())`**, llamar **`refreshRemoteUsers()`** y luego **`listUsersForDisplay()`** — debe haber filas no eliminadas alineadas con JSONPlaceholder y locales si se crean con **`createLocalUser`**.

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [ ] Solo documentación / plantillas / metadatos del repo
- [x] Tooling / CI / configuración de proyecto _(build `5`)_
- [ ] Infraestructura nueva de esquema Realm _(solo reutiliza **`MT-04`**)_
- [ ] UI — SwiftUI _(MT-07)_
- [x] Red — JSONPlaceholder _(consumida vía **`UsersRemoteServicing`** en el repo)_
- [x] Persistencia — Realm / merge lista / exclusions por **`isDeleted`**
- [ ] Navegación — Coordinators _(MT-06)_
- [ ] Internacionalización
- [ ] Ubicación / permisos
- [ ] Validaciones _(MT-09)_
- [ ] Pruebas automatizadas
- [ ] Cambio que requiera migración de datos reales _(N/A para este cambio)_

---

## Definición de hecho (según ticket)

Según `docs/development-plan.md` — **MT-05 — Repository merge**:

- [x] Orquestación red + Realm + política de lista (**upsert**, no resucitar **`isDeleted`**).
- [x] Caché tras GET (**Realm** persistido).
- [x] Filtros: **`isDeleted`** excluido de **`listUsersForDisplay`**.
- [x] Crear / editar local reflejable en modelo de lista (**`createLocalUser`**, **`setEditedName`/`setEditedEmail`**).
- [x] Compila (**verificar con Xcode / `xcodebuild` antes del merge**).

_Siguiente: **MT-06** Coordinators (inyección **`UserRepository`** y rutas)._
