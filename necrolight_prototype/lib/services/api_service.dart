import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/sensor_data.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        print('Login failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        print('Registration failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<bool> sendCriticalNotification(SensorData sensorData, String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.notificationEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode({
          'type': 'critical_symptom',
          'message': 'Critical symptom detected: Score ${sensorData.symptomScore.toStringAsFixed(1)}',
          'sensorData': sensorData.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Notification send error: $e');
      return false;
    }
  }

  Future<bool> uploadSensorData(List<SensorData> dataList, String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/sensor-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode({
          'data': dataList.map((data) => data.toJson()).toList(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Data upload error: $e');
      return false;
    }
  }
}
