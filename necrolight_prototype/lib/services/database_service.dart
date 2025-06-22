import 'package:hive_flutter/hive_flutter.dart';
import '../models/sensor_data.dart';
import '../utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late Box<SensorData> _sensorDataBox;
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SensorDataAdapter());
    }
    
    // Open boxes
    _sensorDataBox = await Hive.openBox<SensorData>(AppConstants.sensorDataBoxName);
  }

  Future<void> saveSensorData(SensorData data) async {
    await _sensorDataBox.put(data.id, data);
  }

  List<SensorData> getAllSensorData() {
    return _sensorDataBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<SensorData> getSensorDataByDateRange(DateTime start, DateTime end) {
    return _sensorDataBox.values
        .where((data) => 
            data.timestamp.isAfter(start) && 
            data.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<SensorData> getLatestSensorData(int count) {
    final allData = getAllSensorData();
    return allData.take(count).toList();
  }

  Future<void> deleteSensorData(String id) async {
    await _sensorDataBox.delete(id);
  }

  Future<void> clearAllData() async {
    await _sensorDataBox.clear();
  }

  List<SensorData> getCriticalSymptomData() {
    return _sensorDataBox.values
        .where((data) => data.status == 'critical')
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Map<String, int> getSymptomStatusStats() {
    final allData = getAllSensorData();
    int normal = 0, warning = 0, critical = 0;
    
    for (final data in allData) {
      switch (data.status) {
        case 'normal':
          normal++;
          break;
        case 'warning':
          warning++;
          break;
        case 'critical':
          critical++;
          break;
      }
    }
    
    return {
      'normal': normal,
      'warning': warning,
      'critical': critical,
    };
  }

  void dispose() {
    _sensorDataBox.close();
  }
}
