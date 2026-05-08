# MT-04 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-04] Realm: UserObject, apiId, borrado lógico (isDeleted) y schemaVersion 1
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-04-realm-user-schema?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-04 (Realm schemas)** del plan (`docs/development-plan.md`): introduce **`UserObject`** como modelo persistido con **`apiId`** (índice; **`0`** usuarios solo locales), **`isDeleted`** como **tombstone** de borrado lógico (**`MT-11`** / política de merge en **`MT-05`**), campos de snapshot remoto alineados al **`UserDTO`**, y **`editedName` / `editedEmail`** para overrides locales previstos en **`MT-08`**.

Se añaden **`UserPrimaryKey`** (claves estables `remote-{apiId}` vs UUID para alta local), extensiones **`applyRemoteSnapshot` / `init(localId:remote:)`** desde **`UserDTO`** (uso **dentro de transacciones Realm**; **`applyRemoteSnapshot`** **no modifica `isDeleted`** para no reactivar filas dadas de baja al rehacer GET).

**`RealmBootstrap.configureDefault()`** fija **`schemaVersion: 1`** y un **`migrationBlock`** inicial documentado; la app invoca la configuración **al arranque** antes de leer la URL del Realm por defecto.

**Versión marketing** `1.0.0`, **build binario `4`**. **`CHANGELOG`**: bloque **`### Build 4 — MT-04 Realm schemas`** arriba del resto (política acumulativa).

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-04 — Modelos Realm y borrado lógico (`UserObject`, `apiId`, `isDeleted`, migración) |
| Rama | `feature/MT-04-realm-user-schema` |
| Base | `develop` |
| **Jira** | [UFLOW-104](https://acme-payments.atlassian.net/browse/UFLOW-104) _(instancia / clave de ejemplo; convención `UFLOW-10N` ↔ MT-0N — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `4` |

Registro de cambios: **`CHANGELOG.md`** → **`## [1.0.0]`**; bloque superior **`### Build 4 — MT-04 Realm schemas`** (debajo permanecen builds 3, 2 y 1).

---

## Cambios realizados

- **`UserObject`**: PK **`localId`**; **`apiId`**; **`isDeleted`**; **`isLocallyCreated`**; campos de texto para UI (incl. dirección, geo, company).
- **`UserPrimaryKey`** + **`UserObject.primaryKey(for: UserDTO)`**.
- **`RealmBootstrap`**: **`schemaVersion`** = **1** + migración inicial.
- **`App/userflowApp`**: **`RealmBootstrap.configureDefault()`** antes de **`Realm.Configuration.defaultConfiguration.fileURL`**.
- Eliminado **`PersistenceModuleMarker.swift`**.
- **`CURRENT_PROJECT_VERSION = 4`**; **CHANGELOG** Build 4 documentado.

---

## Git / historial de la rama

Cuatro commits sobre `develop`:

1. `feat(MT-04): add UserObject schema, primary key rules and Realm bootstrap` (`99a2930`)
2. `feat(MT-04): configure default Realm at launch; CHANGELOG build 4` (`0b486f2`)
3. `feat(MT-04): preserve isDeleted when applying remote snapshot` (`1afe989`)
4. `docs: add MT-04 pull request description draft`

*(Los hashes corresponden a la rama publicada; cambian si se reescribe historial.)*

---

## Capturas (solo si aplica)

**N/A** — sin cambios visuales.

---

## Cómo probarlo

1. Abrir **`userflow.xcodeproj`**, destino **iOS 15+**.
2. **Product → Build** (`⌘B`).
3. **General → Identity**: **Versión `1.0.0`**, **Build `4`**.
4. _(Opcional)_ Ejecutar la app: el arranque debe aplicar **`RealmBootstrap`** sin crash; la primera apertura efectiva de **`Realm()`** (p. ej. en **`MT-05`**) aplicará esquema **`v1`**.

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [ ] Solo documentación / plantillas / metadatos del repo
- [x] Tooling / CI / configuración de proyecto _(build `4`)_
- [x] Infraestructura (Realm esquema / arranque)
- [ ] UI — SwiftUI
- [ ] Red — JSONPlaceholder _(MT-03 ya entregado; este PR no cambia cliente)_
- [x] Persistencia — Realm / preparación merge / borrado lógico _(esquema y reglas de clave / tombstone)_
- [ ] Navegación — Coordinators _(MT-06)_
- [ ] Internacionalización
- [ ] Ubicación / permisos
- [ ] Validaciones _(MT-09)_
- [ ] Pruebas automatizadas
- [ ] Cambio que requiera migración de datos reales _(solo primera versión de esquema; usuarios existentes de app store N/A aún)_

---

## Definición de hecho (según ticket)

Según `docs/development-plan.md` — **MT-04 — Realm schemas**:

- [x] **`UserObject`** definido.
- [x] **`apiId`** persistido (incl. **`0`** como convención solo-local).
- [x] **`isDeleted`** para borrado lógico (tombstone).
- [x] Migración / **`schemaVersion`** establecida (**`1`** en este PR).
- [x] Compila (**verificado con `xcodebuild` en la rama antes de abrir PR**).

_Merge API + Realm en lista (**`MT-05`**)._
