# MT-08 — Pull request hacia `develop`

**Title (GitHub):**

```
[MT-08] Detalle usuario: campos completos, hero avatar, edición nombre/email en Realm
```

**Compare:**

https://github.com/rapser/userflow/compare/develop...feature/MT-08-user-detail?expand=1

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-08** (`docs/development-plan.md`): pantalla **detalle** con el mismo lenguaje agrupado/lista (cards sobre fondo **`secondarySystemGroupedBackground`**), **avatar** por defecto (**SF Symbol**), **todos** los campos alineados al modelo persistido (contacto, dirección, geo, empresa, identificadores) y **edición** de **nombre** y **correo** vía **`UserRepository.setLocalDisplayEdits`** (**una transacción Realm**; campos vacíos → quitan override y vuelven al snapshot sincronizado tras **Guardar**).

Nuevo **`UserDetailSnapshot`** + **`userDetailSnapshot(localId:)`**; lista sigue usando **`UserListItem`** — al volver atrás se ve el merge **MT-05** con los textos mostrados actualizados.

**Build `8`**, marketing **`1.0.0`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-08 — Pantalla detalle |
| Rama | `feature/MT-08-user-detail` |
| Base | `develop` |
| Jira (ej.) | [UFLOW-108](https://acme-payments.atlassian.net/browse/UFLOW-108) |

---

## Versión

| Campo | Valor |
|--------|--------|
| Marketing | `1.0.0` |
| Build | `8` |

---

## Cómo probar

1. Lista → abrir usuario → comprobar bloques y enlaces (tel/mail/web).
2. **Editar** → cambiar nombre/email → **Guardar**; volver a lista y ver tarjeta actualizada.
3. Borrar texto de un campo y guardar → debe volver al valor sincronizado de Realm (override `nil`).

---

## Git

```bash
git log develop..feature/MT-08-user-detail --oneline
```

_Siguiente: **MT-09** validadores reutilizables (refinar reglas de alto en creación/edición)._
