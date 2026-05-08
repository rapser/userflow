<!-- Mantén el mismo contenido que `docs/templates/pull_request_template.md` (fuente canónica). GitHub usa esta ruta por defecto. -->

<!--
  En GitHub el "título" del PR es el primer campo del formulario.
  Usa un formato uniforme, por ejemplo:
  [MT-02] Foundations: estructura, Alamofire verificado, i18n base
-->

## Título del pull request (campo superior en GitHub)

_Reemplaza esta línea por la misma frase que pongas en el campo **Title** del PR: `[MT-NN] Descripción breve en español`._

---

## Descripción

_Explica en español qué problema resuelve este PR, el alcance del ticket y cualquier decisión técnica relevante para el revisor._

---

## Ticket

| Campo | Valor |
|--------|--------|
| Ticket | MT-NN — _título según `docs/development-plan.md`_ |
| Rama | `feature/MT-NN-<slug-corto>` |
| Base | `develop` |
| **Jira** | _Clave + enlace (ver abajo); sustituye por tu instancia real cuando exista._ |

### Trazabilidad Jira (backlog)

En entornos corporativos el PR suele enlazar la historia o tarea en Jira. Aquí usamos un **proyecto y URL de ejemplo** (no resuelven a un sistema real); mantienen el mismo aspecto que en un equipo fintech con Atlassian.

**Convención sugerida** para alinear el código del ticket del plan interno (`MT-NN`) con una clave estilo Jira:

| Plan interno | Clave Jira (ejemplo) |
|----------------|----------------------|
| MT-01 | `UFLOW-101` |
| MT-02 | `UFLOW-102` |
| MT-NN | `UFLOW-10N` — _usa dos dígitos: MT-07 → `UFLOW-107`_ |

**Enlace (dummy, misma clave que arriba):**

`https://acme-payments.atlassian.net/browse/UFLOW-10N`

_Para el cuerpo del PR en Markdown, copia el patrón (reemplaza `UFLOW-10N` por tu clave, p. ej. MT-01):_

`[UFLOW-101](https://acme-payments.atlassian.net/browse/UFLOW-101)`

_En la organización real sustituye `acme-payments` por el subdominio de vuestra instancia y `UFLOW` por el prefijo del proyecto Jira._

---

## Versión / release

| Campo | Valor |
|--------|--------|
| Versión de marketing | _p. ej. `1.0.0`_ |
| Build | _incrementa con cada ticket fusionado: MT-01 → 1, MT-02 → 2, …_ |

Registro de cambios: `CHANGELOG.md`.

---

## Cambios realizados

- _Lista concisa de lo que cambió (archivos, capas, comportamiento)._

---

## Capturas (solo si aplica)

_Si el ticket incluye UI, flujos visibles o estados que convenga mostrar, adjunta imágenes o video corto. Si no aplica, escribe **N/A** y elimina esta sección o déjala indicada como sin capturas._

<!-- Arrastra aquí capturas de Simulador/dispositivo -->

---

## Cómo probarlo

_Pasos en español: Simulador/dispositivo, idioma, rutas de la app, datos de prueba._

---

## Checklist — tipo de cambio (marca lo que corresponda)

_Ayuda a clasificar qué entra en la app en este PR. Puede haber varias casillas marcadas._

- [ ] Solo documentación / plantillas / metadatos del repo
- [ ] Tooling / CI / configuración de proyecto (sin pantalla nueva)
- [ ] Infraestructura (SPM, targets, despliegue mínimo, sin feature de usuario visible)
- [ ] UI — SwiftUI (lista, detalle, formularios, modales…)
- [ ] Red — cliente API / JSONPlaceholder / Alamofire
- [ ] Persistencia — Realm / merge / borrado lógico
- [ ] Navegación — Coordinators / flujo entre pantallas
- [ ] Internacionalización — String Catalog / ES — EN
- [ ] Ubicación / permisos (When In Use, etc.)
- [ ] Validaciones / reglas reutilizables
- [ ] Pruebas automatizadas (unit / UI)
- [ ] Cambio que puede afectar compatibilidad o requiere migración (breve nota abajo)

_Notas de compatibilidad o riesgos (opcional):_

---

## Definición de hecho (según ticket)

_Copia o enlaza los criterios del MT correspondiente desde `docs/development-plan.md` y márcalos al revisar._
