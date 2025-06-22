class AppConstants {
  // BLE UUIDs
  static const String serviceUUID = '12345678-1234-1234-1234-123456789abc';
  static const String characteristicUUID = '87654321-4321-4321-4321-cba987654321';
  
  // API endpoints
  static const String baseUrl = 'https://your-api-server.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String notificationEndpoint = '/notifications';
  
  // Symptom score thresholds
  static const double normalThreshold = 30.0;
  static const double warningThreshold = 80.0;
  static const double criticalThreshold = 81.0;
  
  // Colors
  static const int normalColor = 0xFF4CAF50; // Green
  static const int warningColor = 0xFFFF9800; // Orange
  static const int criticalColor = 0xFFF44336; // Red
  
  // SharedPreferences keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  
  // Database
  static const String sensorDataBoxName = 'sensor_data';
}
