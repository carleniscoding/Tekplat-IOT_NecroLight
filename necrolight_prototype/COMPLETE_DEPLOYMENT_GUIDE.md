# NecroLight Flutter Web - Complete Deployment Guide to Vercel

## Prerequisites

### 1. Enable Windows Developer Mode (REQUIRED)
Flutter web build requires symlink support, which needs Developer Mode on Windows.

**Steps:**
1. Press `Win + R`, type `ms-settings:developers`, press Enter
2. In Settings → Privacy & Security → For Developers
3. Turn ON "Developer Mode"
4. Restart your computer if prompted

### 2. Install Required Tools
- Flutter SDK (already installed ✓)
- Git (for version control)
- Vercel CLI (optional but recommended)

## Step-by-Step Deployment Process

### Phase 1: Prepare the Flutter Project

#### 1. Clean and Setup Project
```powershell
# Navigate to project directory
cd "c:\Users\TOSHIBA\Documents\Semester_2\DesainRekayasaPerangkatLunak\Tubes3\vunguard-rpl\Tekplat-IOT_NecroLight\necrolight_prototype"

# Clean project
flutter clean

# Get dependencies
flutter pub get
```

#### 2. Build Flutter Web App
```powershell
# Build for web with release optimization
flutter build web --release

# Alternative with additional optimizations
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

### Phase 2: Configure for Vercel Deployment

#### 3. Verify Build Output
After successful build, you should have:
```
build/web/
├── index.html
├── main.dart.js
├── flutter.js
├── flutter_service_worker.js
├── manifest.json
├── version.json
├── assets/
├── canvaskit/
└── icons/
```

#### 4. Vercel Configuration
Your current `vercel.json` is already configured correctly:
```json
{
  "public": "build/web"
}
```

This tells Vercel to serve all files from the `build/web` directory as static files.

#### 5. Git Configuration
Your `.gitignore` is already updated to include build files:
```ignore
# Note: Commented out /build/ so web build files are included for deployment
# /build/
```

### Phase 3: Deploy to Vercel

#### 6. Commit and Push to GitHub
```powershell
# Add all files including build output
git add .

# Commit changes
git commit -m "feat: add Flutter web build for Vercel deployment"

# Push to GitHub
git push origin main
```

#### 7. Deploy on Vercel
1. Go to [vercel.com](https://vercel.com)
2. Click "New Project"
3. Import your GitHub repository
4. Vercel will automatically detect the `vercel.json` configuration
5. Click "Deploy"

### Phase 4: Verification

#### 8. Test Deployment
Once deployed, test these aspects:
- [ ] App loads correctly
- [ ] All assets (images, icons) display properly
- [ ] Routing works (if using Flutter routing)
- [ ] Responsive design on different screen sizes
- [ ] Console shows no critical errors

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Developer Mode Not Enabled
**Error:** "Building with plugins requires symlink support"
**Solution:** Enable Developer Mode as described in Prerequisites

#### Issue 2: Build Files Not Deployed
**Error:** Vercel shows empty or minimal files
**Solution:** Ensure `/build/` is not in `.gitignore` and files are committed

#### Issue 3: 404 Errors on Routes
**Error:** Direct URL access shows 404
**Solution:** Add routing rules to `vercel.json`:
```json
{
  "public": "build/web",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

#### Issue 4: Assets Not Loading
**Error:** Images or fonts not displaying
**Solution:** Check asset paths in `pubspec.yaml` and ensure they're in `build/web/assets/`

## Advanced Configuration

### Custom Domain
1. In Vercel dashboard → Project Settings → Domains
2. Add your custom domain
3. Configure DNS records as instructed

### Environment Variables
1. In Vercel dashboard → Project Settings → Environment Variables
2. Add any required environment variables
3. Redeploy the project

### Performance Optimization
Add to `vercel.json`:
```json
{
  "public": "build/web",
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

## Success Checklist

- [ ] Developer Mode enabled on Windows
- [ ] Flutter project builds successfully (`flutter build web --release`)
- [ ] Build files are committed to Git
- [ ] Vercel project is connected to GitHub repository
- [ ] App is accessible at Vercel URL
- [ ] All functionality works as expected

## Support

If you encounter issues:
1. Check the Flutter logs: `flutter build web --release --verbose`
2. Check Vercel build logs in the dashboard
3. Verify all files are properly committed with `git ls-files build/web/`

---

**Project:** NecroLight IoT Wearable Device App
**Framework:** Flutter Web
**Deployment:** Vercel Static Site
**Last Updated:** $(Get-Date -Format "yyyy-MM-dd HH:mm")
