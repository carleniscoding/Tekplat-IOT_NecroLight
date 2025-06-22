import 'package:flutter/material.dart';

class AppAssets {  // NecroLight Logo Files
  static const String necroLightLogo = 'assets/icons/Necrolight_logo.PNG';
  static const String necroLightTitle = 'assets/icons/Necrolight_title.PNG';
  
  // Images
  static const String necroLightBackground = 'assets/images/Necrolight_background.png';
  static const String splashScreen = 'assets/images/splash_screen.png';
  static const String dashboardBackground = 'assets/images/dashboard_background.png';
  
  // Medical Icons
  static const String heartIcon = 'assets/icons/heart_icon.png';
  static const String temperatureIcon = 'assets/icons/temperature_icon.png';
  static const String accelerometerIcon = 'assets/icons/accelerometer_icon.png';
  static const String bluetoothIcon = 'assets/icons/bluetooth_icon.png';
  
  // Helper method to safely load images with fallback
  static Widget safeImage(String assetPath, {
    double? width,
    double? height,
    Widget? fallback,
    BoxFit fit = BoxFit.contain,
  }) {
    try {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return fallback ?? Container(
            width: width ?? 60,
            height: height ?? 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE53E3E),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 30,
            ),
          );
        },
      );
    } catch (e) {
      return fallback ?? Container(
        width: width ?? 60,
        height: height ?? 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE53E3E),
        ),
        child: const Icon(
          Icons.medical_services,
          color: Colors.white,
          size: 30,
        ),
      );
    }
  }
}
