"""Package a genuinely compiled iPhone app; never turn sources into a fake IPA."""
import hashlib
import json
import os
from pathlib import Path
import plistlib
import stat
import subprocess
import sys
import zipfile


def package(app: Path, destination: Path):
    if not app.is_dir() or app.suffix != '.app':
        raise ValueError('An Xcode-compiled .app directory is required.')
    info = plistlib.loads((app / 'Info.plist').read_bytes())
    executable = app / info['CFBundleExecutable']
    if not executable.is_file():
        raise ValueError('The app executable is missing. Sources are not an app.')
    if info.get('NSSupportsLiveActivities') is not True:
        raise ValueError('Live Activity support is missing.')
    extensions = list((app / 'PlugIns').glob('*.appex'))
    if len(extensions) != 1:
        raise ValueError('Exactly one Live Activity extension must be embedded.')
    widget_info = plistlib.loads((extensions[0] / 'Info.plist').read_bytes())
    if widget_info.get('NSExtension', {}).get('NSExtensionPointIdentifier') != 'com.apple.widgetkit-extension':
        raise ValueError('The embedded extension is not a WidgetKit extension.')
    widget_executable = extensions[0] / widget_info['CFBundleExecutable']
    if not widget_executable.is_file():
        raise ValueError('The Live Activity extension executable is missing.')
    if not widget_info['CFBundleIdentifier'].startswith(info['CFBundleIdentifier'] + '.'):
        raise ValueError('The extension identifier must use the app identifier prefix.')

    # Validate both actual Mach-O executables before publishing a package.
    architectures = {}
    for label, binary in [('app', executable), ('widget', widget_executable)]:
        architecture = subprocess.check_output(['xcrun', 'lipo', '-archs', str(binary)], text=True).strip()
        if 'arm64' not in architecture.split():
            raise ValueError(f'{label} is not built for an arm64 iPhone.')
        architectures[label] = architecture

    destination.mkdir(parents=True, exist_ok=True)
    ipa = destination / 'Kiro-Island-unsigned.ipa'
    with zipfile.ZipFile(ipa, 'w', zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(app.rglob('*')):
            if path.is_dir() and not path.is_symlink():
                continue
            name = Path('Payload') / app.name / path.relative_to(app)
            if path.is_symlink():
                entry = zipfile.ZipInfo(str(name))
                entry.create_system = 3
                entry.external_attr = (stat.S_IFLNK | 0o777) << 16
                archive.writestr(entry, os.readlink(path))
            else:
                archive.write(path, str(name))
    with zipfile.ZipFile(ipa) as archive:
        if archive.testzip() is not None:
            raise ValueError('IPA archive integrity failed.')

    metadata = {
        'name': 'Kiro Island',
        'bundleIdentifier': info['CFBundleIdentifier'],
        'extensionBundleIdentifier': widget_info['CFBundleIdentifier'],
        'minimumOSVersion': info.get('MinimumOSVersion'),
        'architectures': architectures,
        'sourceCommit': os.environ.get('GITHUB_SHA'),
        'workflowRun': os.environ.get('GITHUB_RUN_ID'),
        'xcode': subprocess.check_output(['xcodebuild', '-version'], text=True).strip(),
        'sha256': hashlib.sha256(ipa.read_bytes()).hexdigest(),
        'bytes': ipa.stat().st_size,
        'signed': False,
        'deviceTested': False,
        'installation': 'Sign locally with a free Apple Account. Keep the WidgetKit extension.',
    }
    (destination / 'Kiro-Island-build.json').write_text(json.dumps(metadata, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(metadata, indent=2))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit('Usage: package_ipa.py COMPILED_APP.app OUTPUT_DIRECTORY')
    package(Path(sys.argv[1]), Path(sys.argv[2]))
