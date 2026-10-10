Kiro Island, compiled for arm64 iPhone from the source commit attached to this release.

This IPA is **unsigned**. It requires local signing with your own Apple Account before installation. Do not send Apple credentials to GitHub or put them in repository secrets.

Keep `KiroWidget.appex` when signing: it supplies the Live Activity and Dynamic Island. Removing extensions removes Kiro from the island.

Compilation checks the app and its embedded widget. It does not validate lock signals, music behavior, battery use or installation on a physical iPhone.

See `SIN-MAC.md` for the Windows route and free-account renewal limits.
