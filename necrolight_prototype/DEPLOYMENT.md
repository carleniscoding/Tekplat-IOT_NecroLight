# NecroLight Deployment Guide

This guide will help you deploy the NecroLight Flutter app to both Vercel and Firebase.

## Prerequisites

- Node.js installed on your system
- Flutter SDK installed
- Git repository (recommended for easier deployment)

## Quick Deploy

Run the deployment script:
```bash
./deploy.bat
```

## Manual Deployment Instructions

### 1. Build the App

```bash
flutter build web --release
```

### 2. Deploy to Vercel

#### Option A: Using Vercel CLI
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy (run from project root)
vercel --prod
```

#### Option B: Using GitHub Integration
1. Push your code to GitHub
2. Go to [vercel.com](https://vercel.com) and sign in
3. Import your GitHub repository
4. Vercel will automatically detect the Flutter project and deploy it

### 3. Deploy to Firebase

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (only needed once)
firebase init hosting
# Select "Use an existing project" or create a new one
# Choose "build/web" as your public directory
# Configure as single-page app: Yes
# Set up automatic builds: Optional

# Deploy
firebase deploy
```

## Configuration Files

- `vercel.json` - Vercel deployment configuration
- `firebase.json` - Firebase hosting configuration
- `.firebaserc` - Firebase project configuration

## Environment Variables

If you need to set environment variables for production:

### Vercel
Add environment variables in the Vercel dashboard under Settings > Environment Variables

### Firebase
Use Firebase Functions for server-side logic or Firebase Remote Config for client-side configuration

## Custom Domain

### Vercel
1. Go to your project dashboard
2. Navigate to Settings > Domains
3. Add your custom domain

### Firebase
1. Go to Firebase Console > Hosting
2. Click "Add custom domain"
3. Follow the verification steps

## Troubleshooting

### Common Issues

1. **Build fails**: Make sure `flutter build web --release` runs successfully locally
2. **Assets not loading**: Check that all assets are properly declared in `pubspec.yaml`
3. **Routing issues**: Both platforms are configured for single-page app routing
4. **CORS errors**: Configure CORS headers in Firebase or Vercel if using external APIs

### Getting Help

- Vercel: [vercel.com/docs](https://vercel.com/docs)
- Firebase: [firebase.google.com/docs/hosting](https://firebase.google.com/docs/hosting)

## Performance Optimization

- Enable gzip compression (automatically handled by both platforms)
- Use CDN for static assets (built into both platforms)
- Optimize images and assets before deployment
- Enable caching headers (configured in firebase.json)
