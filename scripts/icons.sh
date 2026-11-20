#!/usr/bin/env bash
# Rebuild the favicons, the apple-touch icon, the logo PNG and the og:image from the SVG sources.
# Needs rsvg-convert, ImageMagick (`magick`) and chromium (or set CHROMIUM). Headless only:
# Chromium runs with a clean environment, so no window opens.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
web="$root/web"
chrome="${CHROMIUM:-$(command -v chromium || command -v chromium-browser || command -v google-chrome)}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

for size in 16 32 48; do
  rsvg-convert -w "$size" -h "$size" "$web/favicon.svg" -o "$work/fav-$size.png"
done
cp "$work/fav-16.png" "$web/favicon-16.png"
cp "$work/fav-32.png" "$web/favicon-32.png"
magick "$work/fav-16.png" "$work/fav-32.png" "$work/fav-48.png" "$web/favicon.ico"
rsvg-convert -w 180 -h 180 "$web/favicon.svg" -o "$web/apple-touch-icon.png"
rsvg-convert -w 512 -h 512 "$web/logo.svg" -o "$web/logo-512.png"

mkdir -p "$work/home" "$work/run"; chmod 700 "$work/run"
env -i PATH="$PATH" HOME="$work/home" XDG_RUNTIME_DIR="$work/run" \
  "$chrome" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
  --user-data-dir="$work/profile" --window-size=1200,630 --virtual-time-budget=3000 \
  --screenshot="$work/og.png" "file://$root/scripts/og-image.html" >/dev/null 2>&1
magick "$work/og.png" -strip "$web/og-image.png"
echo "icons and og-image.png written to $web"
