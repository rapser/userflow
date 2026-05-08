# MT-07 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-07] Lista usuarios: merge API+Realm, tarjetas, searchable y navegación a detalle (iOS 15)
```

**Abrir el PR en el navegador:**

https://github.com/rapser/userflow/compare/develop...feature/MT-07-user-list?expand=1

_Pega desde **«Cuerpo del PR»** abajo._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra **MT-07** (`docs/development-plan.md`): **pantalla raíz única** de usuarios **sin tabs** — **`GET /users`** vía **`UserRepository.refreshRemoteUsers()`**, proyección Realm **`listUsersForDisplay()`**, **`.searchable`** sobre nombre/username/teléfono/email/ciudad, **pull-to-refresh**, estilo **agrupado** (fondo secundario + tarjetas blancas redondeadas), avatar por defecto tipo **SF Symbol**, acciones **+** (coordinator existente) y **tap** → detalle con **`NavigationLink(destination:tag:selection:)`** (**iOS 15**).

Si falla la red, se muestra **aviso** y se mantiene **caché Realm** cuando exista. Tras cerrar el sheet de alta (placeholder **MT-10**), se **recarga la lista** desde Realm.

**Build `7`**, **Marketing `1.0.0`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-07 — Lista principal de usuarios (JSON/API + Realm) |
| Rama | `feature/MT-07-user-list` |
| Base | `develop` |
| **Jira** | [UFLOW-107](https://acme-payments.atlassian.net/browse/UFLOW-107) _(ejemplo — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `7` |

**`CHANGELOG.md`**: **`### Build 7 — MT-07 User list`**.

---

## Cambios realizados

- **`UsersListViewModel.swift`**, **`UserListCardRow.swift`**, lista en **`UsersListCoordinatorHostView.swift`**.
- **`Localizable.xcstrings`**: `users.list.*`.
- **`CURRENT_PROJECT_VERSION = 7`**.

---

## Git / historial de la rama

```bash
git log develop..feature/MT-07-user-list --oneline
```

---

## Cómo probarlo

1. Simulador iOS 15+, **Build `7`**.
2. Al abrir: debe cargar JSONPlaceholder y listar usuarios en tarjetas.
3. **Buscar** en la barra de búsqueda; **pull to refresh**; **tap** en fila → detalle; **+** → sheet (placeholder **MT-10**).

---

## Checklist

- [x] Lista + API/Realm merge
- [x] `.searchable`
- [x] Sin tabs
- [x] Navegación a detalle (**`MT-08`** refina UI)
- [x] async/await en ViewModel (**`refreshUsers`** / **`loadInitial`**)

---

## Definición de hecho (plan)

- [x] Pantalla principal usuarios desde red + caché Realm.
- [x] Sin tabs; datos para tarjeta (nombre, username, teléfono, email, ciudad).
- [x] Estilo inspirado agrupado; botón crear coordinado.
- [x] Compila en Xcode.

_Siguiente: **MT-08** — detalle completo y edición nombre/email._
