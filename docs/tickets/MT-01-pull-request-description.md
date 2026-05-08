# MT-01 — Pull request hacia `develop`

**Campo Title en GitHub (copiar):**

```
[MT-01] Bootstrap: gitignore, iOS 15, verificación Realm SPM, versión 1.0.0 y documentación
```

**Abrir el PR en el navegador (base `develop` ← rama feature):**

https://github.com/rapser/userflow/compare/develop...feature/MT-01-bootstrap-ios15-gitignore?expand=1

_Pega el bloque **“Cuerpo del PR”** de abajo en la descripción del pull request._

---

## Cuerpo del PR (Description)

## Descripción

Este PR cierra el ticket **MT-01 (Bootstrap)** del plan interno: homogeneiza el entorno de Xcode/Swift en el repositorio, fija el despliegue mínimo en **iOS 15** alineado al enunciado, y demuestra que **RealmSwift** enlazado por SPM resuelve y compila sin introducir aún lógica de pantallas. Se añaden además **CHANGELOG**, **plantilla de PR** (trazabilidad tipo Jira de ejemplo) y **versión de marketing 1.0.0** con **build 1**, de forma que el historial y los siguientes MT queden trazables con el mismo estándar que en un backlog corporativo.

Decisión relevante: en `userflowApp` se accede a `Realm.Configuration.defaultConfiguration.fileURL` en el `init` para **forzar el enlace** del binario Realm sin abrir un flujo de usuario; el resto de persistencia llega en tickets posteriores.

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-01 — Bootstrap: `.gitignore`, iOS 15 mínimo, verificar SPM Realm |
| Rama | `feature/MT-01-bootstrap-ios15-gitignore` |
| Base | `develop` |
| **Jira** | [UFLOW-101](https://acme-payments.atlassian.net/browse/UFLOW-101) _(instancia / clave de ejemplo; convención `UFLOW-10N` ↔ MT-0N — ver `docs/templates/pull_request_template.md`)_ |

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | `1.0.0` |
| Build | `1` |

Registro de cambios: `CHANGELOG.md` — sección **[1.0.0]**.

---

## Cambios realizados

- `.gitignore` en raíz orientado a Xcode, Swift y SwiftPM (sin ignorar `Package.resolved` versionado).
- `IPHONEOS_DEPLOYMENT_TARGET = 15.0` en proyecto y target de la app.
- `userflowApp`: `import RealmSwift` y lectura de la URL de configuración por defecto de Realm (verificación MT-01).
- `Package.resolved` y referencias SPM existentes (Realm, Alamofire) coherentes con la premisa manual del plan.
- `docs/development-plan.md`: desglose de tickets y alcance técnico.
- `CHANGELOG.md`, `README.md` (visión general del producto; README exhaustivo en MT-13 / merge `develop` → `main`), `docs/templates/pull_request_template.md`, `.github/pull_request_template.md` (copia GitHub del anterior), y borradores de PR en `docs/tickets/`.
- Deja de versionar `UserInterfaceState.xcuserstate` (estado local de Xcode; ya cubierto por `.gitignore`).

---

## Git / historial de la rama

El contenido de MT-01 está **consolidado en un único commit** sobre `develop` (squash previo al merge), con mensaje:

`feat(MT-01): bootstrap iOS target, Realm verify, versioning and docs`

Así la revisión en GitHub se centra en un diff coherente con el ticket, sin ruido de muchos commits intermedios.

---

## Capturas (solo si aplica)

**N/A** — MT-01 no introduce cambios de UI visibles; la verificación es compilación y ajustes de proyecto.

---

## Cómo probarlo

1. Abrir `userflow.xcodeproj` en Xcode con **iOS 15+** como destino (Simulador o dispositivo).
2. **Product → Clean Build Folder** (opcional), luego **Build**; confirmar éxito con **RealmSwift** resuelto.
3. Opcional **Run**: la app muestra la plantilla inicial; no hay nueva pantalla funcional que capturar.
4. En **Target → General → Identity**: **Version** `1.0.0`, **Build** `1`.

---

## Checklist — tipo de cambio (marca lo que corresponda)

- [x] Solo documentación / plantillas / metadatos del repo
- [ ] Tooling / CI / configuración de proyecto (sin pantalla nueva)
- [x] Infraestructura (SPM, targets, despliegue mínimo, sin feature de usuario visible)
- [ ] UI — SwiftUI (lista, detalle, formularios, modales…)
- [ ] Red — cliente API / JSONPlaceholder / Alamofire
- [ ] Persistencia — Realm / merge / borrado lógico
- [ ] Navegación — Coordinators / flujo entre pantallas
- [ ] Internacionalización — String Catalog / ES — EN
- [ ] Ubicación / permisos (When In Use, etc.)
- [ ] Validaciones / reglas reutilizables
- [ ] Pruebas automatizadas (unit / UI)
- [ ] Cambio que puede afectar compatibilidad o requiere migración (breve nota abajo)

_Notas de compatibilidad o riesgos (opcional):_ Ninguno relevante para usuarios finales; el mínimo de despliegue queda explícitamente en **15.0**.

---

## Definición de hecho (según ticket)

Según `docs/development-plan.md` — **MT-01 — Bootstrap**:

- [x] `.gitignore` en raíz (Xcode / Swift / SwiftPM).
- [x] `IPHONEOS_DEPLOYMENT_TARGET` = **15** (proyecto + target).
- [x] **RealmSwift** (SPM manual, premisa del plan) resuelve y compila; verificación con `import RealmSwift` en el entry point de la app.

_No incluye la primera incorporación del paquete Realm (premisa previa al ticket)._
