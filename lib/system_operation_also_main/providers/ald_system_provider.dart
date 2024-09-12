import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/ald_system_simulation_service.dart';

class ALDSystemProvider with ChangeNotifier {
  final ALDSystemSimulationService _simulationService = ALDSystemSimulationService();
  StreamSubscription<void>? _simulationSubscription;

  ALDSystemProvider() {
    startSimulation();
  }

  // Getters
  bool get n2GenActive => _simulationService.n2GenActive;
  double get n2Flow => _simulationService.n2Flow;
  double get mfcSetpoint => _simulationService.mfcSetpoint;
  double get mfcActualFlow => _simulationService.mfcActualFlow;
  bool get frontlineHeaterActive => _simulationService.frontlineHeaterActive;
  double get frontlineTemperature => _simulationService.frontlineTemperature;
  double get frontlineSetpoint => _simulationService.frontlineSetpoint;
  double get chamberPressure => _simulationService.chamberPressure;
  double get chamberTemperature => _simulationService.chamberTemperature;
  bool get backlineHeaterActive => _simulationService.backlineHeaterActive;
  double get backlineTemperature => _simulationService.backlineTemperature;
  double get backlineSetpoint => _simulationService.backlineSetpoint;
  double get pcSetpoint => _simulationService.pcSetpoint;
  double get pcActualPressure => _simulationService.pcActualPressure;
  bool get pumpActive => _simulationService.pumpActive;
  bool get v1Open => _simulationService.v1Open;
  bool get v2Open => _simulationService.v2Open;
  bool get h1Active => _simulationService.h1Active;
  bool get h2Active => _simulationService.h2Active;
  double get h1Temperature => _simulationService.h1Temperature;
  double get h2Temperature => _simulationService.h2Temperature;
  double get h1Setpoint => _simulationService.h1Setpoint;
  double get h2Setpoint => _simulationService.h2Setpoint;


  // Control methods
  void toggleN2Gen() {
    _simulationService.toggleN2Gen();
    notifyListeners();
  }

  void toggleMFC() {
    if (_simulationService.mfcSetpoint > 0) {
      _simulationService.setMFCSetpoint(0);
    } else {
      _simulationService.setMFCSetpoint(100); // Set to a default value when activating
    }
    notifyListeners();
  }

  void toggleFrontlineHeater() {
    _simulationService.toggleFrontlineHeater();
    notifyListeners();
  }

  void toggleBacklineHeater() {
    _simulationService.toggleBacklineHeater();
    notifyListeners();
  }

  void togglePump() {
    _simulationService.togglePump();
    notifyListeners();
  }

  void toggleValve(String valve) {
    _simulationService.toggleValve(valve);
    notifyListeners();
  }

  void toggleHeater(String heater) {
    _simulationService.toggleHeater(heater);
    notifyListeners();
  }


  void setMFCSetpoint(double setpoint) {
    _simulationService.setMFCSetpoint(setpoint);
    notifyListeners();
  }

  void setFrontlineSetpoint(double setpoint) {
    _simulationService.setFrontlineSetpoint(setpoint);
    notifyListeners();
  }

  void setBacklineSetpoint(double setpoint) {
    _simulationService.setBacklineSetpoint(setpoint);
    notifyListeners();
  }

  void setPCSetpoint(double setpoint) {
    _simulationService.setPCSetpoint(setpoint);
    notifyListeners();
  }


  void setHeaterSetpoint(String heater, double setpoint) {
    _simulationService.setHeaterSetpoint(heater, setpoint);
    notifyListeners();
  }

  void startSimulation() {
    _simulationSubscription = _simulationService.startContinuousSimulation().listen((_) {
      notifyListeners();
    });
  }

  void stopSimulation() {
    _simulationSubscription?.cancel();
  }

  void handleRecipeStep(Map<String, dynamic> parameters) {
    parameters.forEach((key, value) {
      switch (key) {
        case 'v1':
          if (_simulationService.v1Open != value) toggleValve('v1');
          break;
        case 'v2':
          if (_simulationService.v2Open != value) toggleValve('v2');
          break;
        case 'purge_valve':
        // Assuming purge_valve is controlled by both v1 and v2 being closed
          if (value == true) {
            if (_simulationService.v1Open) toggleValve('v1');
            if (_simulationService.v2Open) toggleValve('v2');
          }
          break;
        case 'frontline_heater':
          if (_simulationService.frontlineHeaterActive != value) toggleFrontlineHeater();
          break;
        case 'backline_heater':
          if (_simulationService.backlineHeaterActive != value) toggleBacklineHeater();
          break;
      // Add more cases as needed for other components
      }
    });
    notifyListeners();
  }


  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }

  // Methods to check if parameters are within normal ranges
  bool isReactorPressureNormal() => chamberPressure >= 0.9 && chamberPressure <= 1.1;
  bool isReactorTemperatureNormal() => chamberTemperature >= 145 && chamberTemperature <= 155;
  bool isPrecursorTemperatureNormal(String precursor) {
    if (precursor == 'Precursor A') {
      return h1Temperature >= 28 && h1Temperature <= 32;
    } else if (precursor == 'Precursor B') {
      return h2Temperature >= 28 && h2Temperature <= 32;
    }
    return false;
  }

  void emergencyStop() {
    _simulationService.toggleN2Gen(); // Turn off N2 generator
    _simulationService.setMFCSetpoint(0); // Set MFC to 0
    _simulationService.toggleFrontlineHeater(); // Turn off frontline heater
    _simulationService.toggleBacklineHeater(); // Turn off backline heater
    _simulationService.togglePump(); // Turn off pump
    _simulationService.toggleValve('v1'); // Close valve 1
    _simulationService.toggleValve('v2'); // Close valve 2
    _simulationService.toggleHeater('h1'); // Turn off heater 1
    _simulationService.toggleHeater('h2'); // Turn off heater 2
    notifyListeners();
  }
}