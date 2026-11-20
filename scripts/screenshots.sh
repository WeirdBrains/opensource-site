#!/usr/bin/env bash
# Refresh web/images/projects/<slug>.webp from each live site in data/projects.json.
# Headless Chromium only: no window ever opens, and no display variables are passed.
# Usage: scripts/screenshots.sh [slug ...]   (no arguments: every project)
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
chrome="${CHROMIUM:-$(command -v chromium || command -v chromium-browser || command -v google-chrome)}"
out="$root/web/images/projects"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$out"

want=("$@")
while IFS=$'\t' read -r slug url; do
  if [ ${#want[@]} -gt 0 ] && [[ ! " ${want[*]} " =~ " $slug " ]]; then continue; fi
  echo "capturing $slug <- $url"
  mkdir -p "$work/home" "$work/run"; chmod 700 "$work/run"
  env -i PATH="$PATH" HOME="$work/home" XDG_RUNTIME_DIR="$work/run" \
    "$chrome" --headless=new --disable-gpu --hide-scrollbars \
    --user-data-dir="$work/profile-$slug" --window-size=1440,900 \
    --virtual-time-budget=10000 --screenshot="$work/$slug.png" "$url" >/dev/null 2>&1
  magick "$work/$slug.png" -resize 1200x -quality 80 "$out/$slug.webp"
done < <(python3 -c 'import json,sys
for p in json.load(open(sys.argv[1])): print(p["slug"], p["site"], sep="\t")' "$root/data/projects.json")
