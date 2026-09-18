#!/bin/bash
# Builds Stopwatch.app in this directory. Run: ./build.sh && open Stopwatch.app
set -e
cd "$(dirname "$0")"
APP=Stopwatch.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
swiftc -O main.swift -o "$APP/Contents/MacOS/Stopwatch"

# App icon: render 1024px PNG, downscale into an iconset, convert to .icns
mkdir -p "$APP/Contents/Resources"
TMP=$(mktemp -d)
swiftc makeicon.swift -o "$TMP/makeicon" && "$TMP/makeicon" "$TMP/icon.png"
mkdir "$TMP/AppIcon.iconset"
for s in 16 32 128 256 512; do
    sips -z $s $s "$TMP/icon.png" --out "$TMP/AppIcon.iconset/icon_${s}x${s}.png" >/dev/null
    sips -z $((s*2)) $((s*2)) "$TMP/icon.png" --out "$TMP/AppIcon.iconset/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$TMP/AppIcon.iconset" -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf "$TMP"
cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Stopwatch</string>
    <key>CFBundleIdentifier</key><string>local.stopwatch</string>
    <key>CFBundleExecutable</key><string>Stopwatch</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>LSUIElement</key><true/>
</dict>
</plist>
EOF
echo "Built $APP"
