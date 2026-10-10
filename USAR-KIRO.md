# Usar Kiro en el iPhone

## En la isla

Abrí Kiro y tocá **Llevar a Kiro a la isla**. Mantené presionada la Dynamic Island para expandirla: la mano activa Saludo, la nota musical activa Música y la luna hace descansar a Kiro fuera de la isla. También podés elegir sus cinco emociones desde la app.

Al volver a Kiro, saluda si hay una sesión activa. Hace gestos breves y después queda quieto; no tiene una animación permanente. iOS decide si aparece en la isla principal o en una burbuja cuando otras apps también la usan.

## Música con Atajos en iOS 27

1. En **Atajos**, creá un nuevo atajo y buscá **Cambiar emoción de Kiro**.
2. Agregá esa acción y elegí la emoción **Música**. Podés nombrar el atajo «Kiro música».
3. Abrí el atajo, entrá en **Editar → Automatización** y agregá **App**.
4. Elegí Spotify o Música y el evento **Se abre**. Guardá el atajo.
5. Abrí la app elegida y comprobá si Kiro cambia de pose. Si iOS solicita permitir la ejecución, completá el aviso en el iPhone.

Este evento sucede al abrir la app, incluso si no reproduce nada. No sigue canciones ni pausas. Para volver al reposo, elegí **Con vos** desde Kiro o creá otro atajo con la emoción **Reposo**. Evitá usar el cierre de Spotify o Música como señal de pausa: pueden seguir sonando en segundo plano.

Para consultar reproducción real de Apple Music, usá **Conectar Apple Music** dentro de Kiro y luego la acción **Consultar Apple Music para Kiro** en un atajo. Consulta sólo ese momento; la observación continua funciona mientras Kiro está abierta. Spotify usa la activación al abrir la app en esta versión.

Las automatizaciones personales se configuran en el iPhone. Instalar Kiro añade sus acciones, pero no crea esos activadores. [Agregar automatizaciones en iOS 27](https://support.apple.com/en-euro/guide/shortcuts/apdfbdbd7123/10.0/ios/27), [activador App](https://support.apple.com/en-euro/guide/shortcuts/apde31e9638b/10.0/ios/27).

## Bloqueo y descanso

**Probar señales de bloqueo** es experimental: iOS puede dejar de entregarlas cuando suspende la app. No detecta de manera fiable cada encendido o desbloqueo ni reconoce quién usa el teléfono. La emoción **Pregunta** sigue disponible desde un botón o un atajo.

Tras una hora sin acciones, la vista pasa a Dormido. La actividad permanece hasta que uses **Descansar** o iOS la termine.

## Renovar gratis desde esta PC

Los perfiles de una cuenta Apple gratuita vencen a los **7 días**. Antes de que caduquen:

1. Conectá el iPhone por USB y desbloquealo.
2. Abrí iloader y seleccioná el dispositivo. Iniciá sesión localmente si lo solicita.
3. Usá **Import IPA** y elegí el mismo archivo `Kiro-Island-unsigned.ipa`.
4. Conservá `KiroWidget.appex` y completá la firma e instalación con la misma cuenta Apple.
5. Volvé a abrir Kiro y activá su sesión.

La IPA original queda sin firmar: iloader aplica una firma nueva al instalar. No hace falta recompilar el código sin cambios ni pagar una suscripción. Los cambios de código sí requieren una nueva compilación. [Límites de la cuenta Apple gratuita](https://developer.apple.com/help/account/basics/about-your-developer-account/).

SideStore ofrece otra ruta para renovar desde el teléfono; su configuración adicional está enlazada en [SIN-MAC.md](SIN-MAC.md).
