# Kiro Island · primera base nativa

Destino solicitado: **iPhone 17 con iOS 27**. Proyecto SwiftUI + ActivityKit, con un mínimo de iOS 17 y APIs públicas. Puede compilarse con Xcode en un equipo propio o en un equipo macOS estándar de GitHub, y firmarse desde Windows.

**La app y su extensión ya compilaron correctamente para iPhone.** La [compilación verificada](https://github.com/lucas-spinelli/kiro-island-ios/actions/runs/38082331144) usó Xcode 26.6 y produjo una IPA arm64 de 168.269 bytes, sin firma. La IPA de descarga se firma localmente con una cuenta Apple para instalarla. El funcionamiento real debe comprobarse en el iPhone; `COMPILACION.json` conserva la versión de Xcode, el commit y la huella SHA-256 del resultado.

**Si no tenés una Mac, seguí [SIN-MAC.md](SIN-MAC.md)**: el flujo incluido compila en GitHub y genera una IPA sin firmar para instalación local desde Windows con una cuenta Apple gratuita.

## Qué incluye

- Kiro vectorial, con su silueta original, cinco emociones y manos sólo en saludo.
- Presentaciones compacta, mínima, expandida y de pantalla bloqueada.
- Sesión iniciada por vos, controles en la app y botones en la isla expandida.
- Acciones de Atajos para cambiar emoción, saludar y hacer descansar a Kiro.
- Apple Music: consulta puntual de reproducción y observación mientras Kiro está abierta, con autorización explícita. No controla la música.
- Gestos breves: dos esperas puntuales para mover la pose y asentarse. No hay un bucle de animación ni consultas periódicas.
- Respeto de Reducir movimiento y pantalla Always-On atenuada.

## Instalar para probar con una Mac propia

1. Descomprimí la carpeta en una **Mac con Xcode compatible con iOS 27**.
2. Abrí `KiroIsland.xcodeproj`.
3. En **Signing & Capabilities**, elegí tu equipo de Apple en ambos targets: `KiroIsland` y `KiroWidget`. Si modificás el identificador de la app, el de la extensión debe mantener el mismo prefijo.
4. Elegí tu iPhone como destino y ejecutá. Si Xcode solicita habilitar Developer Mode en el teléfono, seguí sus instrucciones.
5. Abrí Kiro y tocá **Llevar a Kiro a la isla**. Mantené presionada la Dynamic Island para ver sus botones.

No necesita servidor, claves de API ni paquetes externos. También se puede compilar para un simulador de iPhone con Dynamic Island, pero Apple Music y las señales de protección de datos deben verificarse en un dispositivo real.

## Conectar Spotify y Apple Music con Atajos

En iOS 27, creá un atajo con la acción **Cambiar emoción de Kiro** y seleccioná **Música**. Desde **Editar → Automatización**, agregá el activador **App → Se abre** y elegí Spotify o Música. Guardá el atajo y probalo al abrir esa app. En versiones anteriores, la creación puede estar en **Atajos → Automatización**.

Esto activa la pose al **abrir la app**, aunque todavía no esté sonando música. No confirma reproducción ni sigue pausas o cambios de canción. No uses «Se cierra» para asumir que dejó de sonar: puede seguir reproduciendo en segundo plano.

La configuración detallada y la renovación están en [USAR-KIRO.md](USAR-KIRO.md). Las automatizaciones personales se crean en el iPhone; no están configuradas por instalar la IPA.

Para Apple Music podés conectar el permiso en Kiro y usar **Consultar Apple Music para Kiro** en un atajo. La lectura refleja sólo ese momento; si empezás a reproducir después, ejecutá el atajo de nuevo. Spotify no tiene lectura real de reproducción en esta base.

## Bloqueo, saludo y duración

Kiro saluda al volver a su app si existe una sesión. **No detecta de forma general cada encendido o desbloqueo del teléfono.**

La opción **Probar señales de bloqueo**, desactivada inicialmente, reacciona a las notificaciones públicas de protección de datos cuando iOS las entrega: pregunta al quedar inaccesibles y saludo al volver a estar disponibles. Es experimental y puede fallar si la app está suspendida. No es reconocimiento de identidad. La emoción Pregunta siempre se puede activar con un botón o atajo.

Después de una hora sin acciones, `staleDate` marca reposo y la vista muestra a Kiro dormido. **Esto no termina la actividad**: el botón Descansar la elimina. iOS también impone su límite de duración. No hay un proceso permanente para conservarla indefinidamente.

## Consumo y comportamiento de la isla

No se declararon modos de fondo, audio silencioso, actualizaciones frecuentes, red, temporizadores repetitivos ni un reloj de fotogramas. Las animaciones suceden al cambiar de estado y luego Kiro queda quieto. **El gasto real de batería todavía no está medido.**

Kiro usa una actividad propia. Si Spotify, Música u otra app ocupan la isla, iOS puede mostrarlo en una burbuja mínima o priorizar otra actividad; no se inserta dentro del reproductor de esas apps. El sistema decide ubicación, expansión y visibilidad.

La maqueta `Vista-previa.html` permite revisar el diseño con controles simulados. No instala la app, no detecta eventos del iPhone y no prueba las APIs nativas.

## Validación realizada y pruebas pendientes

Se compilaron ambos targets y se verificaron los ejecutables arm64, la extensión embebida y la integridad de la IPA. También se revisaron la estructura del proyecto y los controles de la maqueta HTML.

El usuario confirmó el primer inicio y la aparición de Kiro en la Dynamic Island de su iPhone. Falta validar actualización y finalización de sesiones; probar Atajos con la app suspendida; revisar coexistencia con reproducción real; probar Reducir movimiento, Always-On, VoiceOver y señales de datos protegidos. La automatización de música se dejó para después por elección del usuario. La medición de energía en Instruments requiere una Mac y no forma parte de la ruta gratuita desde Windows. `VALIDACION.json` distingue las comprobaciones realizadas de las pendientes; la compilación por sí sola no demuestra consumo de batería ni funcionamiento en el dispositivo.

## Referencias oficiales

- [ActivityKit y sus límites](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)
- [Animaciones de widgets y Live Activities](https://developer.apple.com/documentation/widgetkit/animating-data-updates-in-widgets-and-live-activities)
- [LiveActivityIntent](https://developer.apple.com/documentation/appintents/liveactivityintent)
- [Protección de datos](https://developer.apple.com/documentation/uikit/uiapplication/isprotecteddataavailable)
- [Reproductor del sistema de Apple Music](https://developer.apple.com/documentation/mediaplayer/mpmusicplayercontroller/systemmusicplayer)
- [Eventos de Atajos](https://support.apple.com/guide/shortcuts/setting-triggers-apde31e9638b/ios)
- [Agregar automatizaciones en iOS 27](https://support.apple.com/en-euro/guide/shortcuts/apdfbdbd7123/10.0/ios/27)
- [Ciclo de vida del SDK de Spotify](https://developer.spotify.com/documentation/ios/concepts/application-lifecycle)
