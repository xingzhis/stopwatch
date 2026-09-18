# Stopwatch

A minimal stopwatch that lives in the macOS menu bar. One Swift file, no dependencies.

- **Left click**: start / pause
- **Right click**: menu with Start/Pause, Reset, Quit

The icon is filled while running and outlined while paused.

## Install

Requires macOS 11+ and the Xcode Command Line Tools (`xcode-select --install`).

```sh
git clone <repo-url> stopwatch
cd stopwatch
./build.sh
cp -R Stopwatch.app /Applications/
open /Applications/Stopwatch.app
```

To update, quit the running app first, then repeat the last three commands.

To start it at login, add it under System Settings → General → Login Items.

## Files

- `main.swift`: the app
- `makeicon.swift`: renders the app icon
- `build.sh`: compiles and assembles `Stopwatch.app`
