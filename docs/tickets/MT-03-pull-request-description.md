# MT-03 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-03] Networking: cliente JSONPlaceholder, DTOs, fetch/delete async y errores tipados
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-03-networking-jsonplaceholder?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-03 (Networking)** del plan (`docs/development-plan.md`): capa **`Core/Networking`** con **DTOs Codable** alineados a **`GET /users`** de JSONPlaceholder (incluye `address.city` para pantallas posteriores), **`NetworkingError`** tipado enlazado a **`AppError`** para UI, **`UsersRemoteServicing`** como contrato y **`JSONPlaceholderUsersClient`** (**Alamofire**, **async/await**) con **`fetchUsers()`** y **`deleteUser(id:)`** (simulación de borrado remoto hasta **MT-11**).

Las DTO exponen inicializadores **`Decodable` `nonisolated`** para coexistir con el aislamiento **MainActor** por defecto del target y el requisito **`Decodable & Sendable`** del serializador async de Alamofire.

**Versión marketing** `1.0.0`, **build binario `3`**. **`CHANGELOG`**: nueva entrada **`### Build 3 — MT-03 Networking`** arriba, **sin borrar** build 2 / 1.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-03 — Networking JSONPlaceholder + errores |
| Rama | `feature/MT-03-networking-jsonplaceholder` |
| Base | `develop` |
| **Jira** | [UFLOW-103](https://acme-payments.atlassian.net/browse/UFLOW-103) _(instancia / clave de ejemplo; convención `UFLOW-10N` ↔ MT-0N — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `3` |

Registro de cambios: **`CHANGELOG.md`** → **`## [1.0.0]`**; bloque superior **`### Build 3 — MT-03 Networking`** (se conservan **`### Build 2`** y **`### Build 1`**).

---

## Cambios realizados

- **`JSONPlaceholderConfiguration`**: URL base y rutas `/users` y `/users/:id`.
- **`UserDTO`**, **`AddressDTO`**, **`GeoDTO`**, **`CompanyDTO`**: payload remoto; **`address.city`** disponible para lista/detalle (MT-07/08).
- **`NetworkingError`**: `invalidHTTPStatus`, `decoding`, `transport` → **`asAppError()`**.
- **`UsersRemoteServicing`**: contrato `fetchUsers()` / `deleteUser(id:)`.
- **`JSONPlaceholderUsersClient`**: validación `200..<300`, `serializingDecodable([UserDTO])` y `serializingData()` en **DELETE**; mapeo de **`AFError`** / **`DecodingError`** a **`NetworkingError`**.
- Eliminado **`NetworkingModuleMarker.swift`** (sustituido por implementación real).
- **`CURRENT_PROJECT_VERSION = 3`** (Debug/Release).

---

## Git / historial de la rama

Entrega en **dos commits** sobre `develop`:

1. `feat(MT-03): add JSONPlaceholder DTOs and networking contracts` (`ef73fa7`)
2. `feat(MT-03): Alamofire async users client and build bump` (`65577f8`)

*(Los hashes corresponden a la rama publicada; cambian si se reescribe historial.)*

---

## Capturas (solo si aplica)

**N/A** — no hay UI nueva; la capa de red no expone pantalla en este ticket.

---

## Cómo probarlo

1. Abrir **`userflow.xcodeproj`**, destino **iOS 15+**.
2. **Product → Build** (`⌘B`).
3. **Target → General → Identity**: **Versión `1.0.0`**, **Build `3`**.
4. _(Opcional)_ En un **preview** o **test manual** (no incluido en el ticket), instanciar **`JSONPlaceholderUsersClient()`** y llamar `fetchUsers()` dentro de un `Task` para verificar respuesta contra la API pública (**requiere red**).

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [ ] Solo documentación / plantillas / metadatos del repo
- [x] Tooling / CI / configuración de proyecto _(build número)_
- [x] Infraestructura (capas Core, wiring futuro Repository)
- [ ] UI — SwiftUI _(sin cambios de pantalla en este PR)_
- [x] Red — cliente API / JSONPlaceholder / Alamofire
- [ ] Persistencia — Realm / merge _(MT-04 / MT-05)_
- [ ] Navegación — Coordinators _(MT-06)_
- [ ] Internacionalización — _(strings existentes MT-02; sin claves nuevas obligatorias)_
- [ ] Ubicación / permisos
- [ ] Validaciones / reglas reutilizables
- [ ] Pruebas automatizadas (unit / UI)
- [ ] Cambio que puede afectar compatibilidad o requiere migración

_Notas:_ la API HTTP es externa y **offline** producirá `NetworkingError.transport` → UI puede mapearlo vía **`asAppError()`** cuando se integre el repositorio.

---

## Definición de hecho (según ticket)

Según `docs/development-plan.md` — **MT-03 — Networking**:

- [x] Cliente JSONPlaceholder.
- [x] DTOs Codable coherentes con la API (`/users`).
- [x] `fetchUsers()` y `deleteUser(id:)` **async**.
- [x] Errores tipados (`NetworkingError` + puente a `AppError`).
- [x] Compila (**autor verificó build** antes de fusionar).

_Repository + merge Realm: **MT-05**._
