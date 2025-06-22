# Assets Directory

This directory contains all the assets used in the NecroLight Flutter application.

## Directory Structure

```
assets/
├── icons/
│   ├── Necrolight_logo.PNG        # Main NecroLight logo ✅ ADDED
│   ├── Necrolight_title.PNG       # NecroLight title text image ✅ ADDED
│   ├── heart_icon.png
│   ├── temperature_icon.png
│   ├── accelerometer_icon.png
│   └── bluetooth_icon.png
├── images/
│   ├── splash_screen.png
│   └── dashboard_background.png
└── fonts/
    └── (custom fonts go here)
```

## Logo Implementation Status: ✅ COMPLETED

The NecroLight logos have been successfully integrated using the `AppAssets` utility class:

### Current Integration:
- **Login Screen**: Main logo (80x80px) + title image ✅
- **Register Screen**: Main logo (60x60px) for consistency ✅  
- **Dashboard Screen**: Logo (32x32px) in app bar ✅

### Asset References:
- `AppAssets.necroLightLogo` → `assets/icons/Necrolight_logo.PNG`
- `AppAssets.necroLightTitle` → `assets/icons/Necrolight_title.PNG`

## Figma Design Integration: ✅ COMPLETED

Modern UI updates applied:
- Clean card-based layouts with subtle shadows
- Professional brand logo placement
- Consistent typography and spacing
- Modern color scheme (white backgrounds, black accents)
- Rounded corners and elevated components

## Directory Structure

```
assets/
├── images/
│   ├── necrolight_logo.png          # Main app logo
│   ├── necrolight_logo_white.png    # White version for dark backgrounds
│   ├── splash_screen.png            # Splash screen image
│   └── dashboard_background.png     # Dashboard background (if needed)
├── icons/
│   ├── heart_icon.png               # Heart rate icon
│   ├── temperature_icon.png         # Temperature sensor icon
│   ├── accelerometer_icon.png       # Motion sensor icon
│   └── bluetooth_icon.png           # Bluetooth connection icon
└── fonts/
    ├── NecroLight-Regular.ttf       # Custom font (if available)
    └── NecroLight-Bold.ttf          # Bold version of custom font
```

## Supported File Formats

### Images
- **PNG** (recommended for logos with transparency)
- **JPG/JPEG** (for photos)
- **SVG** (requires flutter_svg package)
- **WebP** (for optimized images)

### Icons
- **PNG** (with transparency)
- **SVG** (scalable vector icons)

### Fonts
- **TTF** (TrueType Font)
- **OTF** (OpenType Font)

## Usage in Code

### Images
```dart
// Using Image.asset()
Image.asset('assets/images/necrolight_logo.png')

// As background
DecorationImage(
  image: AssetImage('assets/images/dashboard_background.png'),
)
```

### Icons
```dart
// Using Image.asset()
Image.asset('assets/icons/heart_icon.png', width: 24, height: 24)
```

### Fonts (if custom fonts are added)
```dart
Text(
  'NecroLight',
  style: TextStyle(
    fontFamily: 'NecroLight',
    fontWeight: FontWeight.bold,
  ),
)
```

## How to Add New Assets

1. **Place your files** in the appropriate subdirectory
2. **Update pubspec.yaml** if adding new directories or specific files
3. **Run `flutter pub get`** to refresh the asset bundle
4. **Hot restart** the app (not just hot reload) to see new assets

## Recommended Asset Sizes

### App Logo
- **1x**: 120x120px
- **2x**: 240x240px (for @2x displays)
- **3x**: 360x360px (for @3x displays)

### Icons
- **1x**: 24x24px
- **2x**: 48x48px
- **3x**: 72x72px

### Splash Screen
- **1x**: 1080x1920px (9:16 aspect ratio)
- **2x**: 2160x3840px
- **3x**: 3240x5760px
