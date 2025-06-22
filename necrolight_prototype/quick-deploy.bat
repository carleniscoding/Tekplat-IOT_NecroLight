@echo off
echo ========================================
echo NecroLight Flutter Web - Quick Deploy
echo ========================================
echo.

echo [1/5] Checking Developer Mode...
echo If you see symlink errors, enable Developer Mode:
echo Press Win+R, type: ms-settings:developers
echo Turn ON Developer Mode, then restart this script
echo.

echo [2/5] Cleaning Flutter project...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo [3/5] Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    echo Make sure Developer Mode is enabled!
    pause
    exit /b 1
)

echo [4/5] Building Flutter web app...
flutter build web --release
if %errorlevel% neq 0 (
    echo ERROR: Flutter build web failed
    echo Check the error messages above
    pause
    exit /b 1
)

echo [5/5] Checking build output...
if exist "build\web\index.html" (
    echo ✓ Build successful! Files created in build\web\
) else (
    echo ✗ Build failed - no index.html found
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Next steps:
echo ========================================
echo 1. Commit and push to GitHub:
echo    git add .
echo    git commit -m "feat: Flutter web build for deployment"
echo    git push origin main
echo.
echo 2. Deploy on Vercel:
echo    - Go to vercel.com
echo    - Import your GitHub repo
echo    - Vercel will auto-deploy using vercel.json
echo.
echo 3. Your app will be live at the Vercel URL!
echo ========================================
pause
