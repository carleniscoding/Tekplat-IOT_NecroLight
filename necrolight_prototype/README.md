# NecroLight IoT Prototype

A comprehensive Flutter application for monitoring wearable device sensors via Bluetooth Low Energy (BLE) and analyzing symptom scores with real-time health monitoring capabilities.

## Features

### 🔗 BLE Connectivity
- Connect to ESP32 wearable devices via Bluetooth Low Energy
- Real-time sensor data streaming (heart rate, accelerometer)
- Automatic device scanning and connection
- Demo mode for testing without physical devices

### 📊 Health Monitoring
- **Symptom Score Calculation**: Algorithm combining heart rate and accelerometer data
- **Color-coded Status Indicators**:
  - 🟢 Normal (0-30): Green indicator for healthy vitals
  - 🟡 Warning (31-80): Yellow indicator for concerning patterns
  - 🔴 Critical (81-100): Red indicator requiring immediate attention

### 🏥 Smart Notifications
- Automatic server notifications when critical symptoms detected (score ≥ 81)
- REST API integration for emergency alerts
- Real-time data transmission to healthcare providers

### 💾 Data Management
- **Local Storage**: Hive database for offline data persistence
- **Cloud Sync**: Optional server synchronization
- **History Tracking**: Complete timeline of all sensor readings
- **Statistics Dashboard**: Summary of health status over time

### 👤 User Management
- Secure login and registration system
- Token-based authentication with SharedPreferences
- User profile management
- Session persistence across app restarts

### 📱 User Interface
- Modern Material Design 3 interface
- Real-time sensor data visualization
- Interactive charts and progress indicators
- Responsive design for mobile and web platforms

## Project Structure

```
lib/
├── models/
│   ├── sensor_data.dart         # Data model for sensor readings
│   └── user.dart                # User model for authentication
├── services/
│   ├── ble_service.dart         # Bluetooth Low Energy management
│   ├── api_service.dart         # REST API communication
│   ├── auth_service.dart        # Authentication logic
│   └── database_service.dart    # Local database operations
├── screens/
│   ├── login_screen.dart        # User authentication interface
│   ├── register_screen.dart     # New user registration
│   ├── dashboard_screen.dart    # Main monitoring dashboard
│   └── history_screen.dart      # Historical data viewer
├── widgets/
│   ├── status_indicator.dart    # Health status display component
│   └── sensor_card.dart         # Individual sensor value cards
├── utils/
│   └── constants.dart           # App-wide constants and configuration
└── main.dart                    # Application entry point
```

## Dependencies

### Core Dependencies
- `flutter_blue_plus: ^1.32.12` - Bluetooth Low Energy connectivity
- `hive: ^2.2.3` & `hive_flutter: ^1.1.0` - Local database storage
- `http: ^1.2.2` - REST API communication
- `shared_preferences: ^2.3.2` - User session persistence
- `provider: ^6.1.2` - State management
- `permission_handler: ^11.3.1` - Device permissions

### Development Dependencies
- `hive_generator: ^2.0.1` - Code generation for database models
- `build_runner: ^2.4.13` - Build tools for code generation

## Getting Started

### Prerequisites
1. Flutter SDK 3.8.1 or higher
2. Chrome browser (for web development)
3. Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd necrolight_prototype
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate database adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   # For web development
   flutter run -d chrome
   
   # For Android (requires device/emulator)
   flutter run
   ```

### Initial Setup

1. **Create Account**: Register a new user account or login with existing credentials
2. **Connect Device**: Use the "Connect" button to scan for ESP32 devices, or enable "Demo Mode" for testing
3. **Monitor Health**: View real-time sensor data and symptom scores on the dashboard
4. **Review History**: Access the history page to view past readings and trends

## ESP32 Integration

### Expected Data Format
The app expects JSON data from ESP32 devices in this format:
```json
{
  "heartRate": 75,
  "accelX": 0.12,
  "accelY": -0.08,
  "accelZ": 0.95
}
```

### BLE Configuration
- **Service UUID**: `12345678-1234-1234-1234-123456789abc`
- **Characteristic UUID**: `87654321-4321-4321-4321-cba987654321`
- **Device Name**: Must contain "ESP32" or "NecroLight"

## Symptom Score Algorithm

The app calculates symptom scores using a combination of:

1. **Heart Rate Analysis**: Deviation from normal range (60-100 bpm)
2. **Movement Analysis**: Accelerometer magnitude calculation
3. **Combined Scoring**: Weighted algorithm producing 0-100 score

```dart
double heartRateScore = (heartRate - 80).abs() * 0.5;
double accelerometerScore = sqrt(x² + y² + z²) * 10;
double totalScore = (heartRateScore + accelerometerScore).clamp(0, 100);
```

## API Integration

### Server Endpoints
- `POST /api/auth/login` - User authentication
- `POST /api/auth/register` - New user registration
- `POST /api/notifications` - Critical symptom alerts
- `POST /api/sensor-data` - Bulk data synchronization

### Authentication
Uses Bearer token authentication with automatic token refresh and session management.

## Testing

### Demo Mode
Enable demo mode to generate realistic sensor data for testing without physical devices:
- Simulated heart rate: 60-120 bpm
- Random accelerometer values: -1 to 1 g
- Automatic symptom score calculation
- Data updates every 2 seconds

### Manual Testing
1. Test user registration and login flows
2. Verify BLE device scanning and connection
3. Confirm symptom score calculations
4. Test critical alert notifications
5. Validate data persistence and history viewing

## Deployment

### Web Deployment
```bash
flutter build web --release
```

### Android APK
```bash
flutter build apk --release
```

### Production Configuration
Update `lib/utils/constants.dart` with production API endpoints and proper UUIDs for your ESP32 devices.

## Contributing

1. Follow Flutter best practices and coding standards
2. Maintain the existing project structure
3. Add unit tests for new features
4. Update documentation for any API changes
5. Test thoroughly on both web and mobile platforms

## License

This project is part of the Tubes3 vunguard-rpl assignment for Design and Software Engineering course.

---

**Note**: This is a prototype application for educational purposes. For production medical use, ensure compliance with healthcare regulations and undergo proper medical device certification.
