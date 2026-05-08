# MT-06 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-06] Coordinators: NavigationView iOS 15, lista/detalle/alta wiring + UserRepository
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-06-coordinators-navigation?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-06 (Coordinators)** del plan (`docs/development-plan.md`): introduce **`UsersFlowCoordinator`** (`ObservableObject`, `@MainActor`) como capa **`C`** mínima con inyección de **`UserRepository`** y shell SwiftUI válido para **iOS 15** (`NavigationView`, `StackNavigationViewStyle`, `NavigationLink(destination:isActive:)`).

La raíz **`ContentView`** crea **`DefaultUserRepository(remote: JSONPlaceholderUsersClient())`** una sola vez y delega la UI en **`coordinator.rootView()`**. El flujo navega desde el host de lista (**`UsersListCoordinatorHostView`**) a un detalle de ejemplo (`remote-1`). El botón **`+`** presenta sheet de alta con **`UsersCreateCoordinatorHostView`**. **`MT-07`/`MT-08`/`MT-10`** sustituyen los placeholders funcionales/visual.

Strings nuevos ES/EN en **`Localizable.xcstrings`** (`users.coordinator.*`, **`users.detail.navigationTitle`**, **`users.create.navigationTitle`**). **Versión marketing** `1.0.0`, **build binario `6`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-06 — Coordinators (MVVM+C): lista → detalle, crear usuario |
| Rama | `feature/MT-06-coordinators-navigation` |
| Base | `develop` |
| **Jira** | [UFLOW-106](https://acme-payments.atlassian.net/browse/UFLOW-106) _(instancia / clave de ejemplo — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `6` |

Registro de cambios: **`CHANGELOG.md`** → **`### Build 6 — MT-06 Coordinators`** (encima del resto bajo **`## [1.0.0]`**).

---

## Cambios realizados

- **`Coordinators/UsersFlowCoordinator.swift`**: coordinador **`import Combine`** + **`UsersFlowRootView`**.
- **`Features/Users/*/Users*CoordinatorHostView.swift`**: vistas host (lista / detalle / crear).
- **`ContentView`** + **`AppCoordinating`**: cableado inicial.
- **String Catalog** ampliado; eliminados **`*ModuleMarker.swift`** de Users; limpieza de claves vacías que Xcode pudo insertar al compilar (**`xcstrings`**).
- **`CURRENT_PROJECT_VERSION = 6`**.

---

## Git / historial de la rama

Historial **compactado en un solo commit** (squash) encima de `develop`. Mensaje habitual: **`feat(MT-06): ...`**. Para el hash exacto antes del merge:

```bash
git log develop..feature/MT-06-coordinators-navigation --oneline
```

---

## Capturas (solo si aplica)

Opcional — lista placeholder con botón **Probar navegación…**, toolbar **+**, sheet alta.

---

## Cómo probarlo

1. Abrir proyecto, **Build `6`**, ejecutar simulador iOS 15+.
2. Comprobar navegación a detalle ejemplo (posteriormente poblar caché con **`refreshRemoteUsers()`** desde **`MT-07`**).
3. Abrir sheet **Usuario nuevo / New user**, cancelar con **Cancelar**.

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [ ] Solo documentación
- [x] Tooling / build **`6`**
- [ ] UI final de lista (**`MT-07`**)
- [ ] Detalle/información (**`MT-08`**)
- [x] Navegación — Coordinators
- [x] Localización (**String Catalog**)
- [ ] Validaciones (**`MT-09`**)

---

## Definición de hecho (según plan)

Según `docs/development-plan.md` — **MT-06**:

- [x] Navegación SwiftUI válida **iOS 15** (**`NavigationView`** + stack).
- [x] Rutas lista → detalle y flujo crear (sheet/toolbar **`+`**).
- [x] Inyección ligera **`UserRepository`** en **`UsersFlowCoordinator`**.

Siguiente: **MT-07** — lista principal (tarjetas, `.searchable`, consumiendo merge).
