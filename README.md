# userflow

Aplicación iOS (**SwiftUI**) que muestra usuarios combinando la API **[JSONPlaceholder](https://jsonplaceholder.typicode.com/users)** con **persistencia en Realm**, siguiendo arquitectura **MVVM + Coordinator**, red con **Alamofire**, concurrencia con **async/await**, despliegue **iOS 15+** e interfaz y textos del sistema localizados en **español e inglés**. El trabajo por tickets (**MT-01 … MT-12**) cubre el **alcance técnico obligatorio** del plan; **MT-14** (tests unitarios) permanece opcional fuera del núcleo mínimo.

---

## Estado del alcance obligatorio

La siguiente tabla relaciona los requisitos técnicos del enunciado y el plan (**`docs/development-plan.md`**) con la implementación en **`develop`** (consulta **`CHANGELOG.md`** y **`CURRENT_PROJECT_VERSION`** en Xcode para el número de **build** exacto tras cada fusión).

| Requisito | Implementación principal |
|-----------|---------------------------|
| **Lista** desde **GET `/users`** integrada con caché local | `JSONPlaceholderUsersClient.fetchUsers()`, `DefaultUserRepository.refreshRemoteUsers()`, `UsersListViewModel` |
| **Merge en Realm** sin revertir tombstones en upsert remoto | `UserObject.applyRemoteSnapshot` **no modifica `isDeleted`**; clave estable `remote-{apiId}` vía **`UserPrimaryKey`** |
| **Lista UI** sin pestañas, búsqueda local | `UsersListCoordinatorHostView` + `.searchable`, estilo agrupado, `NavigationLink` iOS **15** |
| **Detalle** con campos completos del modelo, avatar por defecto, **editar nombre/correo** en Realm | `UserDetailSnapshot`, `setLocalDisplayEdits`, `UsersDetailCoordinatorHostView` |
| **Alta** local con persistencia y **lista actualizada** | `UsersCreateCoordinatorHostView`, `UsersCreateViewModel`, `createLocalUser`; al cerrar el sheet la lista **recarga** desde Realm |
| **Validadores** reutilizables (vacío trim, correo, teléfono) | `UserFormValidators`, integración en `createLocalUser` y edición detalle (**correo**) |
| **Eliminar**: petición **`DELETE`** simulada + **borrado lógico** + exclusión en lista | `deleteUser(localId:)`, tombstone **`isDeleted`**, filtro en **`listUsersForDisplay()`** |
| **Core Location**: permiso **When In Use**, captura **al pulsar botón en creación**, **presentación lat/long** | `CreationLocationController`, sheet en alta; **`NSLocationWhenInUseUsageDescription`** en **`InfoPlist.strings`** (**en** / **es**) |
| **async/await** (no Combine como capa dominante) | Cliente remoto async, repos y ViewModels con `Task` / `async where` aplique |
| **Errores** legibles ante fallos de red o validación | `NetworkingError`, `AppError`, `UserRepositoryError`, mensajes String Catalog |

**Aclaraciones de alcance:**

- La **ubicación** se muestra **en un sheet tras la lectura puntual**; **no se persiste** en el objeto usuario de Realm (fuera del mínimo exigido en el plan operativo sobre “popup/coords”).
- **JSONPlaceholder `DELETE`** no elimina usuarios realmente del backend; la app cumple ejecutando Alamofire y manteniendo coherencia **solo en dispositivo** vía **`isDeleted`** tras éxito de red donde corresponde (`apiId > 0`).

---

## Arquitectura

- **`App/`**: entrada (`userflowApp`, `ContentView`) e inyección de **`DefaultUserRepository`** + cliente JSONPlaceholder.
- **`Coordinators/`**: `UsersFlowCoordinator` expone navegación (lista única dentro de **`NavigationView`**, detalle por selección, **sheet** de alta).
- **`Features/Users/(List|Detail|Create)`**: vistas SwiftUI ligeras y **ViewModels** `@MainActor` donde aplica (**MVVM**).
- **`Core/Networking/`**: DTO Codable (`UserDTO`), `UsersRemoteServicing`, `JSONPlaceholderUsersClient`.
- **`Core/Persistence/`**: `UserObject` (Realm), claves **`UserPrimaryKey`**, `RealmBootstrap`, **`UserRepository`**, proyección **`UserListItem`**.
- **`Core/Validation/`**: `UserFormValidators` (**MT-09**).
- **`Core/Location/`**: `CreationLocationController` (**MT-12**).

---

## Política de merge y pantalla lista

1. Tras **`GET /users`**, cada DTO actualiza o crea **`UserObject`** en Realm mediante **`applyRemoteSnapshot`**. **`isDeleted` no se pisa** desde el snapshot remoto de forma accidental (el método no lo toca), de modo que un usuario dado de baja **locally** permanece invisible aunque vuelva a aparecer el id en futuros GET simulados.
2. **`listUsersForDisplay()`** devuelve solo filas con **`isDeleted == false`**, aplica orden de presentación definido sobre **`UserListItem`**, y respeta **`editedName` / `editedEmail`** frente al snapshot (**MT-05** / **MT-08**).

Ante fallo de red tras un refresh, la lista puede seguir mostrando **Realm** previo (`UsersListViewModel` avisa cuando aplica).

---

## Internacionalización y privacidad

- Textos UI: **`userflow/Resources/Localizable.xcstrings`** (**en** / **es**).
- **`NSLocationWhenInUseUsageDescription`**: inglés español por **`userflow/Resources/en.lproj/InfoPlist.strings`** y **`es.lproj/InfoPlist.strings`**, coherentes con el uso **When In Use** y **sin** ubicación en segundo plano (sin `UIBackgroundModes` de localización).

---

## Cómo ejecutar el proyecto

1. **Requisitos previos**: macOS con **Xcode** y **Swift** acordes a la toolchain del proyecto (abierto habitualmente desde `userflow.xcodeproj`), simulador o dispositivo **iOS 15+**.
2. **Swift Package Manager**: el repo incluye **`Package.resolved`**. Deben estar resueltos en el equipo los paquetes **Realm Swift** y **Alamofire** (véase Premisa SPM en **`docs/development-plan.md`** si el proyecto se abre por primera vez).
3. Abrir **`userflow.xcodeproj`**, seleccionar el scheme **`userflow`**, compilar (**⌘B**) y ejecutar (**⌘R**).

---

## Versión y registro de cambios

- **Versión marketing** **`1.0.0`**; **CFBundleVersion** (**`CURRENT_PROJECT_VERSION`**) sube **un entero por ticket** fusionado (**`CHANGELOG.md`** describe política).
- Histórico detallado por build: **`CHANGELOG.md`** en la raíz.

---

## Documentación, PRs y Gestión externa (**Confluence** / **Jira**)

**En un proyecto de producto real** lo habitual es que **esta carpeta no se incluya en el mismo repositorio de la aplicación**: aquí **`docs/`** está presente solo **con fines explicativos** (referencia pedagógica, plan MT, borradores de PR y ejemplos de flujo). En el día a día, el material equivalente se puede mantener donde el equipo ya gestiona documentación (**p. ej. Confluence**) y el código queda enfocado en lo que debe construir CI y lanzar tiendas.

- **Plantillas y guías de proceso** (`docs/templates/`, texto largo repetible): encajan mejor en **Confluence** que en Git, si la organización así lo define; este repo muestra uno de los tantos layouts posibles.
- **Enlaces a pull requests**: lo ideal es que **cada PR** guarde la **URL pública/privada** correspondiente dentro del **ticket de Jira** vinculado (campo dedicado, comentario o enlace relacionado). Así el equipo localiza trabajo y revisiones desde **una sola navegación** de gestión, sin depender de buscar hashes en `.md` dentro del código.

Enlaces útiles **en esta copia demo** del repositorio (útil cuando `docs/` sigue aquí):

| Recurso | Contenido |
|---------|-----------|
| [`docs/development-plan.md`](docs/development-plan.md) | Plan de tickets MT y política técnica. |
| [`docs/templates/pull_request_template.md`](docs/templates/pull_request_template.md) | Plantilla de PR (alternativa típica: equivalente en Confluence). Espejo frecuente en **`.github/pull_request_template.md`**. |
| [`docs/tickets/`](docs/tickets/) | Borradores ejemplo de texto de PR; en **Jira+GitHub**, el origen operativo suele ser el ticket enlazando al PR. |

**Git del código:** la rama de integración habitual es **`develop`**; **`develop` → `main`** según política de release.

---

## Roadmap opcional fuera del núcleo obligatorio

- **MT-14**: objetivo unit tests (**validators**, merge repository, mocks HTTP), target de test Xcode.
