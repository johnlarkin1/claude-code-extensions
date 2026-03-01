# App Icon Size Reference

Complete icon size specifications for all supported platforms (as of 2025-2026).

## iOS / iPadOS

| Context | Point Size | Scale | Pixels | Filename |
|---------|-----------|-------|--------|----------|
| App Store | 1024 | 1x | 1024x1024 | icon-1024.png |
| Home (iPhone) | 60 | 3x | 180x180 | icon-60@3x.png |
| Home (iPhone) | 60 | 2x | 120x120 | icon-60@2x.png |
| Home (iPad Pro) | 83.5 | 2x | 167x167 | icon-83.5@2x.png |
| Home (iPad) | 76 | 2x | 152x152 | icon-76@2x.png |
| Home (iPad) | 76 | 1x | 76x76 | icon-76.png |
| Spotlight (iPhone) | 40 | 3x | 120x120 | icon-40@3x.png |
| Spotlight | 40 | 2x | 80x80 | icon-40@2x.png |
| Spotlight (iPad) | 40 | 1x | 40x40 | icon-40.png |
| Settings (iPhone) | 29 | 3x | 87x87 | icon-29@3x.png |
| Settings | 29 | 2x | 58x58 | icon-29@2x.png |
| Settings (iPad) | 29 | 1x | 29x29 | icon-29.png |
| Notification (iPhone) | 20 | 3x | 60x60 | icon-20@3x.png |
| Notification | 20 | 2x | 40x40 | icon-20@2x.png |
| Notification (iPad) | 20 | 1x | 20x20 | icon-20.png |

**Format:** PNG, opaque (no transparency). Apple applies rounded corners automatically.

**Modern Xcode (15+):** A single 1024x1024 icon can be used; Xcode generates other sizes automatically. The generate-icons script provides all sizes for backward compatibility and non-Xcode workflows.

## macOS

| Size (px) | Use |
|-----------|-----|
| 1024x1024 | App Store, high-DPI |
| 512x512 | Finder (large), Retina |
| 256x256 | Finder, Retina small |
| 128x128 | Finder |
| 64x64 | Retina 32pt |
| 32x32 | List views, Dock small |
| 16x16 | List views, menus |

**Format:** PNG. For distribution, macOS uses `.icns` format (can be created with `iconutil`).

**Xcode Contents.json:** Uses `"idiom": "mac"` with scale-based mapping (16pt@1x=16px, 16pt@2x=32px, etc.).

## Android

| Density | Multiplier | Size (px) | Directory |
|---------|-----------|-----------|-----------|
| mdpi | 1x | 48x48 | mipmap-mdpi/ |
| hdpi | 1.5x | 72x72 | mipmap-hdpi/ |
| xhdpi | 2x | 96x96 | mipmap-xhdpi/ |
| xxhdpi | 3x | 144x144 | mipmap-xxhdpi/ |
| xxxhdpi | 4x | 192x192 | mipmap-xxxhdpi/ |
| Play Store | — | 512x512 | playstore/ |

**Format:** PNG. All icons named `ic_launcher.png` within their density directory.

**Adaptive Icons (Android 8+):** Use separate foreground and background layers. The generate-icons script produces standard launcher icons; for adaptive icons, create separate `ic_launcher_foreground.png` and `ic_launcher_background.png` layers manually.

## Web / PWA

| File | Size (px) | Purpose |
|------|-----------|---------|
| favicon-16x16.png | 16x16 | Browser tab |
| favicon-32x32.png | 32x32 | Browser tab (Retina) |
| favicon-48x48.png | 48x48 | Windows site shortcut |
| favicon.ico | 16+32+48 | Multi-resolution fallback |
| apple-touch-icon.png | 180x180 | iOS Safari bookmark |
| icon-192x192.png | 192x192 | PWA home screen |
| icon-512x512.png | 512x512 | PWA splash screen |

**Format:** PNG for individual files, ICO for multi-resolution favicon.

**HTML Integration:**
```html
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="manifest" href="/site.webmanifest">
```

## Source Image Requirements

- **Minimum size:** 1024x1024 pixels
- **Aspect ratio:** Square (1:1) — non-square images will be force-resized
- **Format:** PNG recommended (lossless), JPEG/SVG accepted by ImageMagick
- **Content:** Ensure the design reads well at 16x16 px; avoid fine details
- **Safe area:** Keep critical content within the center 80% for iOS rounded corners and Android adaptive masking

## Xcode AppIcon.appiconset

When `--xcode` is used, the script generates:
```
AppIcon.appiconset/
├── Contents.json      (Xcode metadata)
├── icon-1024.png
├── icon-60@3x.png
├── icon-60@2x.png
└── ... (all required sizes)
```

Drop the entire `AppIcon.appiconset` folder into `Assets.xcassets` in Xcode to use.
