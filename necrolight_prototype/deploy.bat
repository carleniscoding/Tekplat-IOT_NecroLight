@echo off
echo Building Flutter web app...
flutter build web --release

echo.
echo Build complete! 
echo.
echo To deploy to Vercel:
echo 1. Install Vercel CLI: npm i -g vercel
echo 2. Run: vercel --prod
echo.
echo To deploy to Firebase:
echo 1. Install Firebase CLI: npm install -g firebase-tools
echo 2. Run: firebase login
echo 3. Run: firebase init hosting (select existing project or create new one)
echo 4. Run: firebase deploy
echo.
pause
