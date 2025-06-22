import 'package:hive/hive.dart';

part 'sensor_data.g.dart';

@HiveType(typeId: 0)
class SensorData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int heartRate;

  @HiveField(2)
  final double accelerometerX;

  @HiveField(3)
  final double accelerometerY;

  @HiveField(4)
  final double accelerometerZ;

  @HiveField(5)
  final double symptomScore;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String status; // 'normal', 'warning', 'critical'

  SensorData({
    required this.id,
    required this.heartRate,
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.symptomScore,
    required this.timestamp,
    required this.status,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      heartRate: json['heartRate'],
      accelerometerX: json['accelerometerX'].toDouble(),
      accelerometerY: json['accelerometerY'].toDouble(),
      accelerometerZ: json['accelerometerZ'].toDouble(),
      symptomScore: json['symptomScore'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heartRate': heartRate,
      'accelerometerX': accelerometerX,
      'accelerometerY': accelerometerY,
      'accelerometerZ': accelerometerZ,
      'symptomScore': symptomScore,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
