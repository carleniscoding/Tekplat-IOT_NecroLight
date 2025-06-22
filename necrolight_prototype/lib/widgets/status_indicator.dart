import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../utils/constants.dart';

class StatusIndicator extends StatelessWidget {
  final SensorData sensorData;

  const StatusIndicator({super.key, required this.sensorData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: [
              _getStatusColor().withOpacity(0.1),
              _getStatusColor().withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Score: ${sensorData.symptomScore.toStringAsFixed(1)}/100',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusDescription(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: sensorData.symptomScore / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (sensorData.status) {
      case 'normal':
        return Color(AppConstants.normalColor);
      case 'warning':
        return Color(AppConstants.warningColor);
      case 'critical':
        return Color(AppConstants.criticalColor);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (sensorData.status) {
      case 'normal':
        return 'NORMAL';
      case 'warning':
        return 'WARNING';
      case 'critical':
        return 'CRITICAL';
      default:
        return 'UNKNOWN';
    }
  }

  String _getStatusDescription() {
    switch (sensorData.status) {
      case 'normal':
        return 'Your vital signs are within normal range. Keep monitoring.';
      case 'warning':
        return 'Some concerning patterns detected. Please monitor closely.';
      case 'critical':
        return 'Critical symptoms detected! Consider seeking medical attention.';
      default:
        return 'Status unknown';
    }
  }
}
