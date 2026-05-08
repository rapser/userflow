# MT-10 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-10] Alta usuario: formulario local, createLocalUser + validators, lista actualizada
```

**Compare:**

https://github.com/rapser/userflow/compare/develop...feature/MT-10-create-user?expand=1

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra **MT-10** (`docs/development-plan.md`): **formulario SwiftUI** de alta local (**nombre**, **username**, **ciudad** obligatorios; **correo** / **teléfono** opcionales según **`MT-09`**), **`UsersCreateViewModel`**, llamada **`UserRepository.createLocalUser`**. Tras guardar bien, el sheet se cierra y la lista (**`UsersListCoordinatorHostView`**) ya recarga Realm al **`onChange` del coordinator** (**`MT-07`**).

Estilo agrupado alineado a lista/detalle (**`secondarySystemGroupedBackground`**, tarjetas blancas), toolbar **Guardar** compatible **iOS 15**, mensajes **`validation.*`**.

**Build `10`**, marketing **`1.0.0`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-10 — Alta de usuario (formulario local) |
| Rama | `feature/MT-10-create-user` |
| Base | `develop` |

---

## Versión

| Campo | Valor |
|--------|--------|
| Build | `10` |

---

## Cambios

- **`UsersCreateViewModel.swift`**, **`UsersCreateCoordinatorHostView.swift`**
- **`Localizable`** `users.create.*`
- **`CURRENT_PROJECT_VERSION`**, **`CHANGELOG.md`**

---

## Cómo probar

1. **+** → rellena perfil/ciudad obligatorios; correo opcional válido si se rellena.
2. **Guardar**: nuevo usuario en lista tras cerrar sheet; datos inválidos → banner (**`validation.*`**).

---

_Siguiente: **MT-11** eliminar (lógico + API simulada)._
