# MT-12 — Pull request hacia `develop`

**Title (GitHub):**

```
[MT-12] Core Location When In Use: botón en alta + sheet coords + InfoPlist localizado
```

**Compare:**

https://github.com/rapser/userflow/compare/develop...feature/MT-12-core-location?expand=1

---

## Descripción

Este PR cierra **MT-12** (`docs/development-plan.md`): **When In Use** (sin background), **`CLLocationManager.requestLocation()`** al pulsar **Obtener coordenadas** en la pantalla **Usuario nuevo**, **sheet** con latitud/longitud, manejo de denegados y errores. **`NSLocationWhenInUseUsageDescription`** está en **`en.lproj` / `es.lproj`** `InfoPlist.strings` dentro de **`userflow/Resources/`**; **`INFOPLIST_KEY_…`** del proyecto sirve como base en inglés.

**Build `12`**.

---

## Probar

1. **+** → **Obtener coordenadas** → diálogo de sistema → permite → sheet con valores.
2. Denegar permiso → banner con texto localizado (**`users.create.locationDenied`**).
3. Dispositivo en ES → mensaje **Info.plist** del simulador en español cuando aplique bundle `es`.
