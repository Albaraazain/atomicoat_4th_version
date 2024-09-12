import 'package:flutter/foundation.dart';

enum AlarmSeverity { info, warning, critical }

class Alarm {
  final String id;
  final String message;
  final AlarmSeverity severity;
  final DateTime timestamp;
  bool acknowledged;

  Alarm({
    required this.id,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.acknowledged = false,
  });
}

class AlarmProvider with ChangeNotifier {
  List<Alarm> _activeAlarms = [];
  List<Alarm> _alarmHistory = [];

  // Getters
  List<Alarm> get activeAlarms => _activeAlarms;
  List<Alarm> get alarmHistory => _alarmHistory;

  // Method to add a new alarm
  void addAlarm(String message, AlarmSeverity severity) {
    final newAlarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      severity: severity,
      timestamp: DateTime.now(),
    );
    _activeAlarms.add(newAlarm);
    _alarmHistory.add(newAlarm);
    notifyListeners();
  }

  // Method to acknowledge an alarm
  void acknowledgeAlarm(String alarmId) {
    final alarmIndex = _activeAlarms.indexWhere((alarm) => alarm.id == alarmId);
    if (alarmIndex != -1) {
      _activeAlarms[alarmIndex].acknowledged = true;
      _alarmHistory.firstWhere((alarm) => alarm.id == alarmId).acknowledged = true;
      notifyListeners();
    }
  }

  // Method to clear an acknowledged alarm
  void clearAlarm(String alarmId) {
    _activeAlarms.removeWhere((alarm) => alarm.id == alarmId && alarm.acknowledged);
    notifyListeners();
  }

  // Method to clear all acknowledged alarms
  void clearAllAcknowledgedAlarms() {
    _activeAlarms.removeWhere((alarm) => alarm.acknowledged);
    notifyListeners();
  }

  // Method to get alarms by severity
  List<Alarm> getAlarmsBySeverity(AlarmSeverity severity) {
    return _activeAlarms.where((alarm) => alarm.severity == severity).toList();
  }

  // Method to check if there are any critical alarms
  bool hasCriticalAlarms() {
    return _activeAlarms.any((alarm) => alarm.severity == AlarmSeverity.critical);
  }

  // Method to simulate checking for alarms based on system state
  void checkForAlarms(double reactorPressure, double reactorTemperature, Map<String, double> precursorTemperatures) {
    if (reactorPressure > 9.5) {
      addAlarm('High reactor pressure', AlarmSeverity.critical);
    } else if (reactorPressure > 8.0) {
      addAlarm('Reactor pressure approaching upper limit', AlarmSeverity.warning);
    }

    if (reactorTemperature > 290) {
      addAlarm('High reactor temperature', AlarmSeverity.critical);
    } else if (reactorTemperature > 280) {
      addAlarm('Reactor temperature approaching upper limit', AlarmSeverity.warning);
    }

    precursorTemperatures.forEach((precursor, temperature) {
      if (temperature > 95) {
        addAlarm('High $precursor temperature', AlarmSeverity.critical);
      } else if (temperature > 90) {
        addAlarm('$precursor temperature approaching upper limit', AlarmSeverity.warning);
      }
    });
  }

  // Method to get the most recent alarms
  List<Alarm> getRecentAlarms({int count = 5}) {
    return _alarmHistory.reversed.take(count).toList();
  }

  // Method to export alarm history
  String exportAlarmHistory() {
    return _alarmHistory.map((alarm) =>
    '${alarm.timestamp.toIso8601String()},${alarm.severity},${alarm.message},${alarm.acknowledged}'
    ).join('\n');
  }

  // Method to calculate alarm statistics
  Map<String, int> getAlarmStatistics() {
    return {
      'total': _alarmHistory.length,
      'critical': _alarmHistory.where((a) => a.severity == AlarmSeverity.critical).length,
      'warning': _alarmHistory.where((a) => a.severity == AlarmSeverity.warning).length,
      'info': _alarmHistory.where((a) => a.severity == AlarmSeverity.info).length,
      'acknowledged': _alarmHistory.where((a) => a.acknowledged).length,
      'unacknowledged': _alarmHistory.where((a) => !a.acknowledged).length,
    };
  }
}