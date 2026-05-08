# MT-11 — Pull request hacia `develop`

**Title (GitHub):**

```
[MT-11] Eliminar usuario: DELETE simulado + isDeleted + lista actualizada
```

**Compare:**

https://github.com/rapser/userflow/compare/develop...feature/MT-11-delete-user-logical?expand=1

---

## Descripción

Este PR cierra **MT-11** (`docs/development-plan.md`): borrado **lógico** en Realm (**`isDeleted`**), para usuarios remotos **`DELETE`** por **`JSONPlaceholderUsersClient.deleteUser(id:)`** antes del tombstone; usuarios **solo locales** (`apiId == 0`) solo marcan **`isDeleted`**. La lista sigue excluyendo **`isDeleted`** (**`listUsersForDisplay`**); el merge **`applyRemoteSnapshot`** **no** revierte el flag (**`MT-05`/`MT-11`**).

UI en **detalle**: icono papelera, **alert** de confirmación, errores de red en banner, cierre de navegación + **`reloadFromCache`** en lista al éxito.

**Build `11`**, marketing **`1.0.0`**.

---

## Versión

| Field | Value |
|-------|-------|
| Build | `11` |

---

## Probar

1. Usuario remoto → Eliminar → confirma → vuelve a lista sin esa fila; pull-to-refresh no la reactiva.
2. Usuario creado en app (`apiId == 0`) → Eliminar sin petición **`DELETE`**.
3. Sin red → error amistoso y el usuario **no** queda marcado como eliminado.
