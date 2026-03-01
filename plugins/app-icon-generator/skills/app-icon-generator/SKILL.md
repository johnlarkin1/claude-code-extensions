---
name: app-icon-generator
description: This skill should be used when the user asks to "generate app icons", "create app icons", "resize an image for app icons", "prepare icon assets", "make icons for iOS", "make icons for macOS", "make icons for Android", "create favicon", "generate PWA icons", "create Xcode AppIcon", or provides an image and mentions creating icon variants for app distribution.
tools: Read, Write, Bash
---

# App Icon Generator

Generate complete sets of app icon assets for iOS, macOS, Android, and web/PWA from a single source image. Uses ImageMagick to resize and export icons in all required sizes, with optional Xcode-compatible `.appiconset` output.

## Prerequisites

- **ImageMagick** must be installed: `brew install imagemagick`
- Source image should be at least **1024x1024 pixels** and **square** (1:1 aspect ratio)

## Workflow

### 1. Validate the Source Image

Before generating icons, verify the source image meets requirements:

- Confirm the file exists and is a valid image format (PNG, JPEG, SVG, TIFF)
- Check dimensions are at least 1024x1024
- Warn if the image is not square — icons will be force-resized to square
- PNG is preferred (lossless); JPEG is acceptable but may introduce artifacts at small sizes

**Validation commands:**
```bash
# Check ImageMagick is installed
magick --version || echo "ImageMagick not found — install with: brew install imagemagick"

# Check image dimensions
magick identify -format "%wx%h" source.png

# Check if image has transparency (relevant for iOS which requires opaque icons)
magick identify -format "%[channels]" source.png
# Output containing "a" (e.g., "srgba") indicates transparency
```

If the source has transparency and iOS is a target platform, add a solid background:
```bash
magick source.png -background white -flatten source-opaque.png
```

### 2. Determine Target Platforms

Ask the user which platforms to target if not specified. Supported platforms:

| Platform | Key Output |
|----------|-----------|
| `ios` | 15 icon sizes + optional Xcode `.appiconset` |
| `macos` | 7 sizes (16px–1024px) + optional Xcode `.appiconset` |
| `android` | 5 density buckets (mdpi–xxxhdpi) + Play Store 512px |
| `web` | Favicons (16/32/48 + .ico), apple-touch-icon, PWA 192/512 |

Default: all platforms.

### 3. Generate Icons Using the Script

Run the bundled generation script:

```bash
bash "<skill_directory>/scripts/generate-icons.sh" <source-image> [options]
```

**Options:**
- `-o, --output DIR` — Output directory (default: `./app-icons`)
- `-p, --platforms LIST` — Comma-separated: `ios,macos,android,web,all` (default: `all`)
- `--xcode` — Generate Xcode-compatible `AppIcon.appiconset` with `Contents.json`

**Examples:**
```bash
# All platforms, flat PNGs
bash "<skill_directory>/scripts/generate-icons.sh" logo.png

# iOS + Android with Xcode output
bash "<skill_directory>/scripts/generate-icons.sh" logo.png -p ios,android --xcode

# macOS only with Xcode AppIcon.appiconset
bash "<skill_directory>/scripts/generate-icons.sh" logo.png -p macos --xcode

# Web only (favicons + PWA)
bash "<skill_directory>/scripts/generate-icons.sh" logo.png -p web -o ./public

# Custom output directory, all platforms
bash "<skill_directory>/scripts/generate-icons.sh" logo.png -o ./assets/icons --xcode
```

### 4. Report Results

After generation, provide the user with a clear summary. Example format:

```
Generated app icons from: logo.png (1024x1024)
Output: ./app-icons/

  iOS:     15 icons → ./app-icons/ios/AppIcon.appiconset/
  macOS:    7 icons → ./app-icons/macos/AppIcon.appiconset/
  Android:  6 icons → ./app-icons/android/ (mipmap-mdpi through xxxhdpi + Play Store)
  Web:      8 files → ./app-icons/web/ (favicons, .ico, apple-touch-icon, PWA icons)
```

Include platform-specific integration instructions relevant to the user's project (see below). If the project type is known (e.g., Xcode project, React Native, Next.js), tailor the guidance accordingly.

## Integration Notes

### iOS / Xcode

When `--xcode` is used, the output includes a complete `AppIcon.appiconset/` directory with `Contents.json`. To integrate:

1. Open the Xcode project
2. Navigate to `Assets.xcassets`
3. Delete the existing `AppIcon` asset (if any)
4. Drag the generated `AppIcon.appiconset` folder into `Assets.xcassets`

For modern Xcode (15+), a single 1024x1024 icon suffices — Xcode derives other sizes automatically. The script still generates all sizes for backward compatibility.

### Android

Generated icons follow the standard `mipmap-*` directory structure. Copy the density directories into `app/src/main/res/`:

```
app/src/main/res/
├── mipmap-mdpi/ic_launcher.png
├── mipmap-hdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png
```

For adaptive icons (Android 8+), create separate foreground/background layers manually.

### Web

Add the generated web icons to the site root and reference them in HTML:

```html
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
```

The generated `icons-manifest.json` contains the PWA manifest `icons` array — merge it into the project's `site.webmanifest` or `manifest.json`.

## Handling Edge Cases

- **Non-square source:** The script forces square output (`-resize NxN!`). Recommend the user crop to square first for best results. To center-crop a non-square image:
  ```bash
  magick source.png -gravity center -extent 1024x1024 cropped.png
  ```
- **Small source image:** If under 1024x1024, the script warns but still generates. Upscaled icons may appear blurry — recommend starting with a high-resolution source.
- **SVG source:** ImageMagick can rasterize SVG. For best quality rasterization:
  ```bash
  magick -density 300 source.svg -resize 1024x1024 source-rasterized.png
  ```
- **Transparency:** iOS App Store icons must be opaque. If the source has transparency, flatten it before generating:
  ```bash
  magick source.png -background white -flatten source-opaque.png
  ```
- **Existing icons in project:** Before generating, check whether the project already has icon assets. For Xcode projects, look in `*.xcassets/AppIcon.appiconset/`. For Android, check `app/src/main/res/mipmap-*/`. Back up existing icons before overwriting.

## Troubleshooting

Common issues and resolutions:

| Symptom | Cause | Fix |
|---------|-------|-----|
| `magick: command not found` | ImageMagick not installed | `brew install imagemagick` |
| `delegate library support not built-in` | Missing ImageMagick delegates | `brew reinstall imagemagick` |
| Blurry small icons | Source image too small | Start with at least 1024x1024 |
| White border on icons | Source not square | Crop to square before generating |
| Icons rejected by App Store | Transparency in iOS icon | Flatten transparency with `-background white -flatten` |
| `.ico` generation fails | Old ImageMagick version | Update with `brew upgrade imagemagick` |

## Output Directory Structure

When run with `--xcode` and all platforms, the script produces:

```
app-icons/
├── ios/
│   └── AppIcon.appiconset/
│       ├── Contents.json
│       ├── icon-1024.png
│       ├── icon-60@3x.png
│       └── ... (15 PNGs total)
├── macos/
│   └── AppIcon.appiconset/
│       ├── Contents.json
│       ├── icon-1024x1024.png
│       └── ... (7 PNGs total)
├── android/
│   ├── mipmap-mdpi/ic_launcher.png
│   ├── mipmap-hdpi/ic_launcher.png
│   ├── mipmap-xhdpi/ic_launcher.png
│   ├── mipmap-xxhdpi/ic_launcher.png
│   ├── mipmap-xxxhdpi/ic_launcher.png
│   └── playstore/ic_launcher-playstore.png
└── web/
    ├── favicon-16x16.png
    ├── favicon-32x32.png
    ├── favicon-48x48.png
    ├── favicon.ico
    ├── apple-touch-icon.png
    ├── icon-192x192.png
    ├── icon-512x512.png
    └── icons-manifest.json
```

Without `--xcode`, iOS and macOS icons are placed directly in `ios/` and `macos/` as flat PNG files.

## Additional Resources

### Reference Files

- **`references/icon-sizes.md`** — Complete table of all icon sizes, formats, and naming conventions for every platform

### Scripts

- **`scripts/generate-icons.sh`** — Main generation script (ImageMagick-based, all platforms)
