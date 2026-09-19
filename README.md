# Stopwatch

A minimal stopwatch that lives in the macOS menu bar. One Swift file, no dependencies.

- **Left click**: start / pause
- **Double click**: reset to 0:00 (keeps running if it was running)
- **Right click**: menu with Start/Pause, Reset, Quit

The icon shows what a click will do: ▶ while paused, ⏸ while running.

## Install

Requires macOS 11+ and the Xcode Command Line Tools (`xcode-select --install`).

```sh
git clone https://github.com/xingzhis/stopwatch.git stopwatch
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
