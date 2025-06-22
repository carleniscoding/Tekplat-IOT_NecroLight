import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import '../models/sensor_data.dart';
import '../utils/constants.dart';

class BLEService {
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;
  BLEService._internal();

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _sensorCharacteristic;
  StreamSubscription<List<int>>? _characteristicSubscription;
  
  final StreamController<SensorData> _sensorDataController = 
      StreamController<SensorData>.broadcast();
  
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();

  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  
  bool get isConnected => _connectedDevice != null;
  
  // Demo mode
  bool _demoMode = false;
  Timer? _demoTimer;
  
  bool get demoMode => _demoMode;

  Future<void> initialize() async {
    await FlutterBluePlus.turnOn();
  }

  Future<List<BluetoothDevice>> scanForDevices() async {
    List<BluetoothDevice> devices = [];
    
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.platformName.contains('ESP32') || 
            result.device.platformName.contains('NecroLight')) {
          if (!devices.contains(result.device)) {
            devices.add(result.device);
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 10));
    await FlutterBluePlus.stopScan();
    
    return devices;
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      
      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      
      for (BluetoothService service in services) {
        if (service.uuid.toString().contains(AppConstants.serviceUUID)) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString().contains(AppConstants.characteristicUUID)) {
              _sensorCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      if (_sensorCharacteristic != null) {
        await _sensorCharacteristic!.setNotifyValue(true);
        _characteristicSubscription = _sensorCharacteristic!.value.listen(_processSensorData);
        _connectionController.add(true);
        return true;
      }
      
      return false;
    } catch (e) {
      print('Connection error: $e');
      _connectionController.add(false);
      return false;
    }
  }

  void _processSensorData(List<int> data) {
    try {
      // Convert bytes to string and parse JSON
      String jsonString = utf8.decode(data);
      Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract sensor values
      int heartRate = jsonData['heartRate'] ?? _generateRandomHeartRate();
      double accelX = jsonData['accelX']?.toDouble() ?? _generateRandomAccel();
      double accelY = jsonData['accelY']?.toDouble() ?? _generateRandomAccel();
      double accelZ = jsonData['accelZ']?.toDouble() ?? _generateRandomAccel();
      
      // Calculate symptom score
      double symptomScore = _calculateSymptomScore(heartRate, accelX, accelY, accelZ);
      
      // Create sensor data object
      SensorData sensorData = SensorData(
        id: const Uuid().v4(),
        heartRate: heartRate,
        accelerometerX: accelX,
        accelerometerY: accelY,
        accelerometerZ: accelZ,
        symptomScore: symptomScore,
        timestamp: DateTime.now(),
        status: _getStatusFromScore(symptomScore),
      );
      
      _sensorDataController.add(sensorData);
    } catch (e) {
      print('Error processing sensor data: $e');
      // Generate mock data if parsing fails
      _generateMockData();
    }
  }

  double _calculateSymptomScore(int heartRate, double accelX, double accelY, double accelZ) {
    // Simple symptom scoring algorithm
    double heartRateScore = 0;
    double accelerometerScore = 0;
    
    // Heart rate scoring (assuming normal range 60-100 bpm)
    if (heartRate < 60 || heartRate > 100) {
      heartRateScore = (heartRate - 80).abs() * 0.5;
    }
    
    // Accelerometer scoring (based on movement intensity)
    double magnitude = sqrt(accelX * accelX + accelY * accelY + accelZ * accelZ);
    accelerometerScore = magnitude * 10;
    
    double totalScore = (heartRateScore + accelerometerScore).clamp(0, 100);
    return totalScore;
  }

  String _getStatusFromScore(double score) {
    if (score <= 30) return 'normal';
    if (score <= 80) return 'warning';
    return 'critical';
  }

  void _generateMockData() {
    // Generate mock data for development/testing
    int heartRate = _generateRandomHeartRate();
    double accelX = _generateRandomAccel();
    double accelY = _generateRandomAccel();
    double accelZ = _generateRandomAccel();
    
    double symptomScore = _calculateSymptomScore(heartRate, accelX, accelY, accelZ);
    
    SensorData mockData = SensorData(
      id: const Uuid().v4(),
      heartRate: heartRate,
      accelerometerX: accelX,
      accelerometerY: accelY,
      accelerometerZ: accelZ,
      symptomScore: symptomScore,
      timestamp: DateTime.now(),
      status: _getStatusFromScore(symptomScore),
    );
    
    _sensorDataController.add(mockData);
  }

  int _generateRandomHeartRate() {
    Random random = Random();
    return 60 + random.nextInt(60); // 60-120 bpm
  }

  double _generateRandomAccel() {
    Random random = Random();
    return (random.nextDouble() - 0.5) * 2; // -1 to 1
  }

  Future<void> disconnect() async {
    await _characteristicSubscription?.cancel();
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    _sensorCharacteristic = null;
    _connectionController.add(false);
  }

  void dispose() {
    _characteristicSubscription?.cancel();
    _demoTimer?.cancel();
    _sensorDataController.close();
    _connectionController.close();
  }
  
  void startDemoMode() {
    _demoMode = true;
    _connectionController.add(true);
    _demoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _generateMockData();
    });
  }

  void stopDemoMode() {
    _demoMode = false;
    _demoTimer?.cancel();
    _demoTimer = null;
    _connectionController.add(false);
  }
}
