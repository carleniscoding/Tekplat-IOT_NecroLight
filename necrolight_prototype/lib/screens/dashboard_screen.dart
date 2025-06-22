import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/ble_service.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/app_assets.dart';
import '../widgets/status_indicator.dart';
import '../widgets/sensor_card.dart';
import 'history_screen.dart';
import 'emergency_contacts_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BLEService _bleService = BLEService();
  final DatabaseService _databaseService = DatabaseService();
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  StreamSubscription<SensorData>? _sensorDataSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  SensorData? _latestSensorData;
  bool _isConnected = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _bleService.initialize();
    
    _sensorDataSubscription = _bleService.sensorDataStream.listen(_onSensorDataReceived);
    _connectionSubscription = _bleService.connectionStream.listen(_onConnectionChanged);
  }

  void _onSensorDataReceived(SensorData data) async {
    setState(() {
      _latestSensorData = data;
    });

    // Save to local database
    await _databaseService.saveSensorData(data);

    // Send notification if critical
    if (data.symptomScore >= AppConstants.criticalThreshold) {
      final token = _authService.getUserToken();
      if (token != null) {
        await _apiService.sendCriticalNotification(data, token);
      }
    }
  }

  void _onConnectionChanged(bool connected) {
    setState(() {
      _isConnected = connected;
      _isConnecting = false;
    });
  }

  Future<void> _connectToDevice() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      final devices = await _bleService.scanForDevices();
      if (devices.isNotEmpty) {
        await _bleService.connectToDevice(devices.first);
      } else {
        setState(() {
          _isConnecting = false;
        });
        _showSnackBar('No devices found');
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
      });
      _showSnackBar('Connection failed: $e');
    }
  }

  void _toggleDemoMode() {
    if (_bleService.demoMode) {
      _bleService.stopDemoMode();
    } else {
      _bleService.startDemoMode();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            AppAssets.safeImage(
              AppAssets.necroLightLogo,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),        actions: [
          IconButton(
            icon: const Icon(Icons.emergency, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.necroLightBackground),
            fit: BoxFit.cover,
            opacity: 0.4, // 40% opacity
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            // Connection Status
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                          color: _isConnected ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isConnected 
                                  ? (_bleService.demoMode ? 'Demo Mode Active' : 'Device Connected')
                                  : 'Device Disconnected',
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isConnected 
                                  ? 'Receiving data from sensor'
                                  : 'Connect to start monitoring',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!_isConnected || _bleService.demoMode) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (!_isConnected && !_bleService.demoMode)
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                onPressed: _isConnecting ? null : _connectToDevice,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isConnecting 
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Connect Device',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ),
                          ),
                        if (!_isConnected && !_bleService.demoMode)
                          const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _bleService.demoMode ? Colors.orange : const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: _isConnecting ? null : _toggleDemoMode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _bleService.demoMode ? Colors.orange : const Color(0xFFF7F7F7),
                                foregroundColor: _bleService.demoMode ? Colors.white : Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _bleService.demoMode ? 'Stop Demo' : 'Demo Mode',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status Indicator
            if (_latestSensorData != null)
              StatusIndicator(sensorData: _latestSensorData!),
            const SizedBox(height: 16),

            // Sensor Data Cards            // Sensor Data Cards matching Figma design
            if (_latestSensorData != null) ...[
              // Battery Level
              SensorCard(
                title: 'Battery',
                value: '85', // You can calculate this from sensor data
                unit: '%',
                icon: Icons.battery_full,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              
              // Sleepiness Level
              SensorCard(
                title: 'Sleepiness',
                value: _latestSensorData!.symptomScore.toStringAsFixed(0),
                unit: '%',
                icon: Icons.bedtime,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(height: 8),
              
              // Inertia Level
              SensorCard(
                title: 'Inertia',
                value: _latestSensorData!.accelerometerX.abs().toStringAsFixed(0),
                unit: '%',
                icon: Icons.speed,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(height: 8),
              
              // Posture Level
              SensorCard(
                title: 'Posture',
                value: _latestSensorData!.accelerometerY.abs().toStringAsFixed(0),
                unit: '%',
                icon: Icons.accessibility_new,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(height: 8),
              
              // Muscle Level
              SensorCard(
                title: 'Muscle',
                value: _latestSensorData!.accelerometerZ.abs().toStringAsFixed(0),
                unit: '%',
                icon: Icons.fitness_center,
                color: const Color(0xFF6B7280),
              ),              const SizedBox(height: 8),
              
              // Paralysis Level (neutral color)
              SensorCard(
                title: 'Paralysis',
                value: '${(100 - _latestSensorData!.heartRate / 2).toStringAsFixed(0)}',
                unit: '%',
                icon: Icons.warning,
                color: Colors.grey[600]!,
              ),
            ] else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sensors_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No sensor data available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),                      SizedBox(height: 8),
                      Text(
                        'Connect to a device to start monitoring',                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _sensorDataSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
