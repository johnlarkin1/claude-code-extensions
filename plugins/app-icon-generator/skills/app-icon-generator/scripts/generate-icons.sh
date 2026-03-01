#!/usr/bin/env bash
set -euo pipefail

# App Icon Generator
# Generates app icons for iOS, macOS, Android, and Web from a source image.
# Requires: ImageMagick (brew install imagemagick)

usage() {
  cat <<EOF
Usage: $(basename "$0") <source-image> [options]

Options:
  -o, --output DIR       Output directory (default: ./app-icons)
  -p, --platforms LIST   Comma-separated: ios,macos,android,web,all (default: all)
  --xcode                Generate Xcode-compatible AppIcon.appiconset with Contents.json
  -h, --help             Show this help

Examples:
  $(basename "$0") logo.png
  $(basename "$0") logo.png -p ios,android --xcode
  $(basename "$0") logo.png -o ./my-icons -p all --xcode
EOF
  exit 0
}

# --- ImageMagick detection ---
MAGICK_CONVERT=""
MAGICK_IDENTIFY=""

detect_magick() {
  if command -v magick &>/dev/null; then
    MAGICK_CONVERT="magick"
    MAGICK_IDENTIFY="magick identify"
  elif command -v convert &>/dev/null; then
    MAGICK_CONVERT="convert"
    MAGICK_IDENTIFY="identify"
  else
    echo "Error: ImageMagick not found. Install with: brew install imagemagick" >&2
    exit 1
  fi
}

resize_icon() {
  local src="$1" size="$2" dest="$3"
  $MAGICK_CONVERT "$src" -resize "${size}x${size}!" -strip "$dest"
}

# --- Argument parsing ---
SOURCE=""
OUTPUT="./app-icons"
PLATFORMS="all"
XCODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output) OUTPUT="$2"; shift 2 ;;
    -p|--platforms) PLATFORMS="$2"; shift 2 ;;
    --xcode) XCODE=true; shift ;;
    -h|--help) usage ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) SOURCE="$1"; shift ;;
  esac
done

if [[ -z "$SOURCE" ]]; then
  echo "Error: No source image provided" >&2
  usage
fi

if [[ ! -f "$SOURCE" ]]; then
  echo "Error: Source image not found: $SOURCE" >&2
  exit 1
fi

detect_magick

# --- Validate source image ---
SRC_DIMS=$($MAGICK_IDENTIFY -format "%wx%h" "$SOURCE" 2>/dev/null | head -1)
SRC_W="${SRC_DIMS%%x*}"
SRC_H="${SRC_DIMS##*x}"

if [[ "$SRC_W" -lt 1024 || "$SRC_H" -lt 1024 ]]; then
  echo "Warning: Source image is ${SRC_W}x${SRC_H}. Recommended minimum is 1024x1024." >&2
fi

if [[ "$SRC_W" -ne "$SRC_H" ]]; then
  echo "Warning: Source image is not square (${SRC_W}x${SRC_H}). Icons will be force-resized to square." >&2
fi

# --- Platform selection ---
gen_ios=false
gen_macos=false
gen_android=false
gen_web=false

if [[ "$PLATFORMS" == "all" ]]; then
  gen_ios=true; gen_macos=true; gen_android=true; gen_web=true
else
  IFS=',' read -ra plats <<< "$PLATFORMS"
  for p in "${plats[@]}"; do
    case "$p" in
      ios) gen_ios=true ;;
      macos) gen_macos=true ;;
      android) gen_android=true ;;
      web) gen_web=true ;;
      *) echo "Warning: Unknown platform '$p', skipping." >&2 ;;
    esac
  done
fi

echo "=== App Icon Generator ==="
echo "Source:    $SOURCE (${SRC_W}x${SRC_H})"
echo "Output:   $OUTPUT"
echo "Platforms: $PLATFORMS"
echo "Xcode:    $XCODE"
echo ""

# ============================================================
# iOS
# ============================================================
if $gen_ios; then
  if $XCODE; then
    IOS_DIR="$OUTPUT/ios/AppIcon.appiconset"
  else
    IOS_DIR="$OUTPUT/ios"
  fi
  mkdir -p "$IOS_DIR"
  echo "[iOS] Generating icons..."

  # Format: "pixel_size:filename"
  ios_icons=(
    "1024:icon-1024.png"
    "180:icon-60@3x.png"
    "120:icon-60@2x.png"
    "87:icon-29@3x.png"
    "80:icon-40@2x.png"
    "120:icon-40@3x.png"
    "58:icon-29@2x.png"
    "60:icon-20@3x.png"
    "40:icon-20@2x.png"
    "167:icon-83.5@2x.png"
    "152:icon-76@2x.png"
    "76:icon-76.png"
    "40:icon-40.png"
    "29:icon-29.png"
    "20:icon-20.png"
  )

  for entry in "${ios_icons[@]}"; do
    size="${entry%%:*}"
    filename="${entry##*:}"
    resize_icon "$SOURCE" "$size" "$IOS_DIR/$filename"
  done

  if $XCODE; then
    cat > "$IOS_DIR/Contents.json" <<'EOF'
{
  "images": [
    { "filename": "icon-20@2x.png", "idiom": "iphone", "scale": "2x", "size": "20x20" },
    { "filename": "icon-20@3x.png", "idiom": "iphone", "scale": "3x", "size": "20x20" },
    { "filename": "icon-29@2x.png", "idiom": "iphone", "scale": "2x", "size": "29x29" },
    { "filename": "icon-29@3x.png", "idiom": "iphone", "scale": "3x", "size": "29x29" },
    { "filename": "icon-40@2x.png", "idiom": "iphone", "scale": "2x", "size": "40x40" },
    { "filename": "icon-40@3x.png", "idiom": "iphone", "scale": "3x", "size": "40x40" },
    { "filename": "icon-60@2x.png", "idiom": "iphone", "scale": "2x", "size": "60x60" },
    { "filename": "icon-60@3x.png", "idiom": "iphone", "scale": "3x", "size": "60x60" },
    { "filename": "icon-20.png", "idiom": "ipad", "scale": "1x", "size": "20x20" },
    { "filename": "icon-20@2x.png", "idiom": "ipad", "scale": "2x", "size": "20x20" },
    { "filename": "icon-29.png", "idiom": "ipad", "scale": "1x", "size": "29x29" },
    { "filename": "icon-29@2x.png", "idiom": "ipad", "scale": "2x", "size": "29x29" },
    { "filename": "icon-40.png", "idiom": "ipad", "scale": "1x", "size": "40x40" },
    { "filename": "icon-40@2x.png", "idiom": "ipad", "scale": "2x", "size": "40x40" },
    { "filename": "icon-76.png", "idiom": "ipad", "scale": "1x", "size": "76x76" },
    { "filename": "icon-76@2x.png", "idiom": "ipad", "scale": "2x", "size": "76x76" },
    { "filename": "icon-83.5@2x.png", "idiom": "ipad", "scale": "2x", "size": "83.5x83.5" },
    { "filename": "icon-1024.png", "idiom": "ios-marketing", "scale": "1x", "size": "1024x1024" }
  ],
  "info": {
    "author": "app-icon-generator",
    "version": 1
  }
}
EOF
    echo "  Created AppIcon.appiconset with Contents.json"
  fi

  count=$(find "$IOS_DIR" -name '*.png' | wc -l | tr -d ' ')
  echo "  $count icons generated"
fi

# ============================================================
# macOS
# ============================================================
if $gen_macos; then
  if $XCODE; then
    MACOS_DIR="$OUTPUT/macos/AppIcon.appiconset"
  else
    MACOS_DIR="$OUTPUT/macos"
  fi
  mkdir -p "$MACOS_DIR"
  echo "[macOS] Generating icons..."

  macos_sizes=(16 32 64 128 256 512 1024)
  for size in "${macos_sizes[@]}"; do
    resize_icon "$SOURCE" "$size" "$MACOS_DIR/icon-${size}x${size}.png"
  done

  if $XCODE; then
    cat > "$MACOS_DIR/Contents.json" <<'EOF'
{
  "images": [
    { "filename": "icon-16x16.png", "idiom": "mac", "scale": "1x", "size": "16x16" },
    { "filename": "icon-32x32.png", "idiom": "mac", "scale": "2x", "size": "16x16" },
    { "filename": "icon-32x32.png", "idiom": "mac", "scale": "1x", "size": "32x32" },
    { "filename": "icon-64x64.png", "idiom": "mac", "scale": "2x", "size": "32x32" },
    { "filename": "icon-128x128.png", "idiom": "mac", "scale": "1x", "size": "128x128" },
    { "filename": "icon-256x256.png", "idiom": "mac", "scale": "2x", "size": "128x128" },
    { "filename": "icon-256x256.png", "idiom": "mac", "scale": "1x", "size": "256x256" },
    { "filename": "icon-512x512.png", "idiom": "mac", "scale": "2x", "size": "256x256" },
    { "filename": "icon-512x512.png", "idiom": "mac", "scale": "1x", "size": "512x512" },
    { "filename": "icon-1024x1024.png", "idiom": "mac", "scale": "2x", "size": "512x512" }
  ],
  "info": {
    "author": "app-icon-generator",
    "version": 1
  }
}
EOF
    echo "  Created AppIcon.appiconset with Contents.json"
  fi

  count=$(find "$MACOS_DIR" -name '*.png' | wc -l | tr -d ' ')
  echo "  $count icons generated"
fi

# ============================================================
# Android
# ============================================================
if $gen_android; then
  ANDROID_DIR="$OUTPUT/android"
  echo "[Android] Generating icons..."

  density_names=(mdpi hdpi xhdpi xxhdpi xxxhdpi)
  density_sizes=(48 72 96 144 192)

  for i in "${!density_names[@]}"; do
    name="${density_names[$i]}"
    size="${density_sizes[$i]}"
    dir="$ANDROID_DIR/mipmap-$name"
    mkdir -p "$dir"
    resize_icon "$SOURCE" "$size" "$dir/ic_launcher.png"
  done

  # Google Play Store
  mkdir -p "$ANDROID_DIR/playstore"
  resize_icon "$SOURCE" 512 "$ANDROID_DIR/playstore/ic_launcher-playstore.png"

  echo "  6 icons generated (5 densities + Play Store)"
fi

# ============================================================
# Web / PWA
# ============================================================
if $gen_web; then
  WEB_DIR="$OUTPUT/web"
  mkdir -p "$WEB_DIR"
  echo "[Web] Generating icons..."

  # Favicons
  for size in 16 32 48; do
    resize_icon "$SOURCE" "$size" "$WEB_DIR/favicon-${size}x${size}.png"
  done

  # Multi-resolution .ico
  $MAGICK_CONVERT "$SOURCE" \
    \( -clone 0 -resize 16x16 \) \
    \( -clone 0 -resize 32x32 \) \
    \( -clone 0 -resize 48x48 \) \
    -delete 0 \
    -strip "$WEB_DIR/favicon.ico"

  # Apple Touch Icon
  resize_icon "$SOURCE" 180 "$WEB_DIR/apple-touch-icon.png"

  # PWA icons
  resize_icon "$SOURCE" 192 "$WEB_DIR/icon-192x192.png"
  resize_icon "$SOURCE" 512 "$WEB_DIR/icon-512x512.png"

  # Manifest snippet
  cat > "$WEB_DIR/icons-manifest.json" <<'EOF'
{
  "icons": [
    { "src": "favicon-16x16.png", "sizes": "16x16", "type": "image/png" },
    { "src": "favicon-32x32.png", "sizes": "32x32", "type": "image/png" },
    { "src": "favicon-48x48.png", "sizes": "48x48", "type": "image/png" },
    { "src": "apple-touch-icon.png", "sizes": "180x180", "type": "image/png" },
    { "src": "icon-192x192.png", "sizes": "192x192", "type": "image/png", "purpose": "any" },
    { "src": "icon-512x512.png", "sizes": "512x512", "type": "image/png", "purpose": "any" }
  ]
}
EOF

  echo "  8 files generated (3 favicons, .ico, apple-touch-icon, 2 PWA, manifest)"
fi

echo ""
echo "Done! All icons saved to: $OUTPUT"
