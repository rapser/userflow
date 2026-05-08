# MT-02 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-02] Foundations: estructura MVVM+C, catálogo ES/EN, AppError y verificación Alamofire
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-02-foundations?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-02 (Foundations)** según `docs/development-plan.md`: deja preparada la **estructura física y lógica MVVM+C** bajo `userflow/` (**`App`**, **`Core`**, **`Features/Users`**, **`Coordinators`**, **`Resources`**), **verifica** que **Alamofire** ya enlazado por SPM se compila ejercitando `Session.default` junto al toque de Realm en el `init` de la app, y añade **String Catalog** **`Localizable.xcstrings`** con **inglés + español**, más el placeholder compartido **`AppError`**.

No introduce lógica de listado, red JSONPlaceholder ni Realm de dominio: eso llega en **MT-03** y siguientes. Se sube el **build del binario a `2`** (misma versión de marketing **1.0.0**) y se documenta en **`CHANGELOG.md`**.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-02 — Foundations: estructura, verificar Alamofire, i18n base |
| Rama | `feature/MT-02-foundations` |
| Base | `develop` |
| **Jira** | [UFLOW-102](https://acme-payments.atlassian.net/browse/UFLOW-102) _(instancia / clave de ejemplo; convención `UFLOW-10N` ↔ MT-0N — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `2` |

Registro de cambios: **`CHANGELOG.md`** → **`## [1.0.0]`**; dentro, bloque **`### Build 2 — MT-02 Foundations`** en la parte superior (sin quitar **`### Build 1 — MT-01`**).

---

## Cambios realizados

- **Estructura:** `App/` (entrada SwiftUI), `Core/` con subcarpetas **Networking / Persistence / Validation / Location** (marcadores de módulo hasta MT-03…MT-12), `Features/Users/{List,Detail,Create}` (marcadores), `Coordinators/AppCoordinating.swift` (contrato mínimo hasta MT-06).
- **`userflowApp`:** `Alamofire` + `RealmSwift`; `_ = Session.default` además del toque de configuración Realm (**verificación MT-02**).
- **`Resources/Localizable.xcstrings`:** claves base (marca, título **Users/Usuarios**, errores **`AppError`**, **Cancel/OK**, texto de ubicación **When In Use** coherente con MT-12).
- **`Core/AppError.swift`:** errores de dominio inicial (`networkUnavailable`, `decodingFailed`, `unknown`) con mensaje localizable.
- **`ContentView`:** usa claves del catálogo (`common.appDisplayName`, `users.screenTitle`) — shell sin flujo de negocio de usuarios.
- **Proyecto:** `knownRegions` incluye **`es`**; **`CURRENT_PROJECT_VERSION = 2`**; **`INFOPLIST_KEY_NSLocationWhenInUseUsageDescription`** (inglés; flujo completo en MT-12).
- **`CHANGELOG.md`** actualizado para reflejar MT-02 y build **2**.

---

## Git / historial de la rama

El trabajo se entregó en **dos commits atómicos** sobre `develop`, alineados al DoD del ticket (estructura ↔ catálogo/errores/proyecto):

1. `feat(MT-02): add MVVM+C folder scaffold and Core shells` (`b8ad9a8`)
2. `feat(MT-02): add Localizable EN/ES catalogs, AppError and project locales` (`681b4eb`)

*(Los hashes son los de la rama al publicar; pueden variar si se reescribe historial.)*

---

## Capturas (solo si aplica)

_Opcional_: captura del Simulador con **Users** vs **Usuarios** al cambiar idioma del sistema/app. Si no aporta valor, usar **N/A**.

**N/A** — no hay pantallas de producto nuevas; solo etiquetas de ejemplo y estructura.

---

## Cómo probarlo

1. Abrir **`userflow.xcodeproj`**, destino **iOS 15+**.
2. **Product → Build** (`⌘B`) — Alamofire y Realm enlazados.
3. **Run**: comprobar títulos localizados; en ajustes del Simulador o idioma preferido **Español** verificar **«Usuarios»** vs **English** «Users» para `users.screenTitle` (nombre de app **`User Flow`** igual en ES/EN según catálogo).
4. **Target → General → Identity**: **Versión `1.0.0`**, **Build `2`**.
5. (Opcional) Usar vista previa `#Preview` o breakpoint en `AppError.unknown.userFacingMessage` para comprobar cadena catalogada.

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [ ] Solo documentación / plantillas / metadatos del repo
- [x] Tooling / CI / configuración de proyecto (sin pantalla nueva sustancial)
- [x] Infraestructura (estructura, SPM verificado Alamofire, regiones proyecto, build bump)
- [x] UI — SwiftUI (lista, detalle, formularios, modales…) — _solo shell mínimo + textos demo_
- [ ] Red — cliente API / JSONPlaceholder / Alamofire _(solo dependencia tocada para enlace MT-02)_
- [ ] Persistencia — Realm / merge / borrado lógico
- [x] Navegación — Coordinators / flujo entre pantallas — _solo protocolo `AppCoordinating` stub_
- [x] Internacionalización — String Catalog / ES — EN
- [x] Ubicación / permisos (When In Use, etc.) — _propósito plist + claves catálogo base para MT-12_
- [ ] Validaciones / reglas reutilizables
- [ ] Pruebas automatizadas (unit / UI)
- [ ] Cambio que puede afectar compatibilidad o requiere migración (breve nota abajo)

_Notas de compatibilidad o riesgos:_ Ningún cambio visible para usuarios finales de producción hasta tickets de UI/red; compilación debe seguir estable en **`develop`** integrado MT-01.

---

## Definición de hecho (según ticket)

Según `docs/development-plan.md` — **MT-02 — Foundations**:

- [x] Carpetas / grupo (`Core`, `Features/Users`, `Coordinators`, `Resources`, `App`).
- [x] **Alamofire** SPM ya enlazado **comprobado** en el binario (**no** alta inicial del paquete).
- [x] String Catalog **ES** + **EN**.
- [x] Placeholders **`AppError`** compartidos.
- [x] Compila (**verificado por el autor del PR antes de fusionar**).

_Sin lógica de usuarios de negocio en este ticket._
