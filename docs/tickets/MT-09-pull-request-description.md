# MT-09 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-09] Validadores formulario usuario: helpers puros + createLocalUser + email en detalle
```

**Abrir el PR en el navegador:**

https://github.com/rapser/userflow/compare/develop...feature/MT-09-validators?expand=1

_Pega desde «Cuerpo del PR» abajo._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-09** (`docs/development-plan.md`): **helpers puros** de validación (**texto obligatorio tras trim**, **correo** y **teléfono** opcionales), mensajes **`validation.*`** en **Localizable**, **`UserRepositoryError.validationFailed(reason:)`** y uso en **`DefaultUserRepository.createLocalUser`**. En **detalle**, **`UsersDetailViewModel.saveEdits()`** valida el correo con **`trimmedOptionalEmail`** antes de **`setLocalDisplayEdits`**.

**Build `9`**, marketing **`1.0.0`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-09 — Validaciones reutilizables |
| Rama | `feature/MT-09-validators` |
| Base | `develop` (post–**MT-08**) |
| Jira (ej.) | [UFLOW-109](https://acme-payments.atlassian.net/browse/UFLOW-109) |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `9` |

**`CHANGELOG.md`**: **`### Build 9 — MT-09 Reusable user form validators`**.

---

## Cambios realizados

- **`userflow/Core/Validation/UserFormValidators.swift`**
- **`UserRepository.swift`**: **`validationFailed`**, validación **`createLocalUser`**
- **`UsersDetailViewModel.swift`**: email al guardar
- **`Localizable.xcstrings`**: `validation.*`
- **`CURRENT_PROJECT_VERSION = 9`**

---

## Cómo probarlo

1. Simulador iOS 15+, **Build `9`**.
2. Detalle → editar → correo inválido → banner con **`validation.emailInvalid`**.
3. **`createLocalUser`** (cuando **`MT-10`** lo llame o desde depurador): campos obligatorios vacíos / formato email o teléfono inválidos → **`validationFailed`**.

---

## Checklist

- [x] Helpers puros reutilizables
- [x] Integración alta (**`createLocalUser`**) y detalle (email)

_Siguiente: **MT-10** formulario SwiftUI._
