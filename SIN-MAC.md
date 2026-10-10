# Ruta gratuita desde Windows

La app y `KiroWidget` ya compilaron en [GitHub](https://github.com/lucas-spinelli/kiro-island-ios/actions/runs/38082331144), con Xcode 26.6. La IPA arm64 resultante pesa 168.269 bytes y está sin firmar. El [repositorio público](https://github.com/lucas-spinelli/kiro-island-ios) permite repetir el proceso sin una Mac propia.

## Compilar

Este proyecto incorpora `.github/workflows/build-ios.yml`. El flujo sólo se ejecuta manualmente y sólo en un **repositorio público**, usando el equipo estándar `macos-26`. No utiliza equipos grandes, caché, Git LFS, paquetes ni almacenamiento de artefactos de Actions.

Xcode compila la app y la extensión sin firma. El empaquetador comprueba ambos ejecutables arm64, sus identificadores y la extensión WidgetKit antes de generar una IPA. El resultado queda en una **release en borrador**, descargable por el dueño del repositorio. Un fallo de compilación no produce una IPA.

La cuenta Apple y la firma quedan fuera de GitHub. El flujo no requiere suscripción Apple Developer, secretos Apple ni certificados de distribución.

## Instalar desde Windows

1. Descargá `Kiro-Island-unsigned.ipa` de la compilación que terminó correctamente.
2. Usá [iloader oficial](https://github.com/nab138/iloader), con los controladores de dispositivos Apple instalados. La documentación de SideStore indica iTunes o Apple Devices para Windows.
3. Conectá el iPhone por USB y aceptá **Confiar** en el teléfono.
4. Iniciá sesión en iloader con tu cuenta Apple gratuita. Ingresá la contraseña y la verificación directamente en la herramienta, no en el chat ni en GitHub.
5. Instalá la IPA como una aplicación normal, **conservando la extensión `KiroWidget.appex`** y su perfil individual. No uses un contenedor de otras apps para esta prueba.
6. Si iOS bloquea la apertura, entrá en **Ajustes → General → VPN y gestión de dispositivos** (puede decir «administración»). En **App del desarrollador**, elegí la cuenta Apple usada para firmar y completá **Confiar / Permitir y reiniciar**, según el aviso. Si solicita modo desarrollador, entrá en **Ajustes → Privacidad y seguridad → Modo desarrollador**, activalo y completá el reinicio y la confirmación en el iPhone. Estas acciones requieren tu intervención física.
7. Abrí Kiro y activá la sesión en la isla. Probá también con la música del iPhone ocupando la isla.

La compatibilidad final con tu versión de iOS y con la firma de la extensión debe comprobarse al instalar. Preparar el instalador no demuestra que una IPA ya esté instalada.

## Renovación gratuita

Las firmas de una cuenta Apple gratuita caducan a los **7 días**. Hay dos rutas:

- Refirmar e instalar desde Windows con iloader.
- Configurar SideStore para renovar desde el teléfono, siguiendo su [guía oficial](https://docs.sidestore.io/docs/installation/install). Su preparación incluye LocalDevVPN y una primera conexión con el equipo.

La cuenta gratuita también tiene un límite de aplicaciones y de App IDs. Kiro necesita un App ID para la app y otro para la extensión; no debe quitarse la extensión para ahorrar uno.

## Lo que cambia y lo que sigue limitado

Esta ruta elimina la necesidad de tener una Mac. Las restricciones de iOS sobre bloqueo, desbloqueo, reproducción de otras apps y animaciones continuas siguen siendo las descritas en `LEEME.md`.

## Referencias

- [Equipos macOS estándar de GitHub](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)
- [Cuándo GitHub Actions es gratuito](https://docs.github.com/en/billing/concepts/product-billing/github-actions)
- [Descargas de releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [Cuenta Apple gratuita y vencimiento](https://developer.apple.com/help/account/basics/about-your-developer-account/)
- [Preparación en Windows](https://docs.sidestore.io/docs/installation/prerequisites)
- [Confianza y primer inicio con iloader](https://docs.sidestore.io/docs/installation/install)
- [Modo desarrollador en el iPhone](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device)
- [iloader y sus descargas oficiales](https://github.com/nab138/iloader)
