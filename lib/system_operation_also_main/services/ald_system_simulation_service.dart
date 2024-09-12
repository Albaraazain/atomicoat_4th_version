import 'dart:async';
import 'dart:math';

class ALDSystemSimulationService {
  final Random _random = Random();

  // System parameters
  bool _n2GenActive = false;
  double _n2Flow = 0.0;
  double _mfcSetpoint = 0.0;
  double _mfcActualFlow = 0.0;
  bool _frontlineHeaterActive = false;
  double _frontlineTemperature = 25.0;
  double _frontlineSetpoint = 25.0;
  double _chamberPressure = 1.0;
  double _chamberTemperature = 25.0;
  bool _backlineHeaterActive = false;
  double _backlineTemperature = 25.0;
  double _backlineSetpoint = 25.0;
  double _pcSetpoint = 1.0;
  double _pcActualPressure = 1.0;
  bool _pumpActive = false;
  bool _v1Open = false;
  bool _v2Open = false;
  bool _h1Active = false;
  bool _h2Active = false;
  double _h1Temperature = 25.0;
  double _h2Temperature = 25.0;
  double _h1Setpoint = 25.0;
  double _h2Setpoint = 25.0;

  // Getters
  bool get n2GenActive => _n2GenActive;
  double get n2Flow => _n2Flow;
  double get mfcSetpoint => _mfcSetpoint;
  double get mfcActualFlow => _mfcActualFlow;
  bool get frontlineHeaterActive => _frontlineHeaterActive;
  double get frontlineTemperature => _frontlineTemperature;
  double get frontlineSetpoint => _frontlineSetpoint;
  double get chamberPressure => _chamberPressure;
  double get chamberTemperature => _chamberTemperature;
  bool get backlineHeaterActive => _backlineHeaterActive;
  double get backlineTemperature => _backlineTemperature;
  double get backlineSetpoint => _backlineSetpoint;
  double get pcSetpoint => _pcSetpoint;
  double get pcActualPressure => _pcActualPressure;
  bool get pumpActive => _pumpActive;
  bool get v1Open => _v1Open;
  bool get v2Open => _v2Open;
  bool get h1Active => _h1Active;
  bool get h2Active => _h2Active;
  double get h1Temperature => _h1Temperature;
  double get h2Temperature => _h2Temperature;
  double get h1Setpoint => _h1Setpoint;
  double get h2Setpoint => _h2Setpoint;


  // Control methods

  // Control methods
  void toggleN2Gen() {
    _n2GenActive = !_n2GenActive;
  }

  void setMFCSetpoint(double setpoint) {
    _mfcSetpoint = setpoint.clamp(0.0, 1000.0);
  }

  void toggleFrontlineHeater() {
    _frontlineHeaterActive = !_frontlineHeaterActive;
  }

  void toggleBacklineHeater() {
    _backlineHeaterActive = !_backlineHeaterActive;
  }

  void togglePump() {
    _pumpActive = !_pumpActive;
  }

  void toggleValve(String valve) {
    if (valve == 'v1') {
      _v1Open = !_v1Open;
    } else if (valve == 'v2') {
      _v2Open = !_v2Open;
    }
  }

  void toggleHeater(String heater) {
    if (heater == 'h1') {
      _h1Active = !_h1Active;
    } else if (heater == 'h2') {
      _h2Active = !_h2Active;
    }
  }


  void setFrontlineSetpoint(double setpoint) {
    _frontlineSetpoint = setpoint.clamp(25.0, 300.0);
  }

  // Simulation method
  void simulateSystemBehavior() {
    // Simulate N2 Generator
    if (_n2GenActive) {
      _n2Flow = 100.0 + _random.nextDouble() * 10 - 5;
    } else {
      _n2Flow = 0.0;
    }

    // Simulate MFC
    _mfcActualFlow = _mfcSetpoint + _random.nextDouble() * 2 - 1;

    // Simulate Frontline Heater
    if (_frontlineHeaterActive) {
      _frontlineTemperature += (_frontlineSetpoint - _frontlineTemperature) * 0.1;
    } else {
      _frontlineTemperature += (25.0 - _frontlineTemperature) * 0.1;
    }

    // Simulate Chamber
    _chamberPressure += _random.nextDouble() * 0.2 - 0.1;
    _chamberPressure = _chamberPressure.clamp(0.5, 2.0);
    _chamberTemperature += _random.nextDouble() * 2 - 1;
    _chamberTemperature = _chamberTemperature.clamp(20.0, 300.0);

    // Simulate Backline Heater
    if (_backlineHeaterActive) {
      _backlineTemperature += (_backlineSetpoint - _backlineTemperature) * 0.1;
    } else {
      _backlineTemperature += (25.0 - _backlineTemperature) * 0.1;
    }

    // Simulate Pressure Controller
    _pcActualPressure += (_pcSetpoint - _pcActualPressure) * 0.1;

    // Simulate Heaters
    if (_h1Active) {
      _h1Temperature += (_h1Setpoint - _h1Temperature) * 0.1;
    } else {
      _h1Temperature += (25.0 - _h1Temperature) * 0.1;
    }
    if (_h2Active) {
      _h2Temperature += (_h2Setpoint - _h2Temperature) * 0.1;
    } else {
      _h2Temperature += (25.0 - _h2Temperature) * 0.1;
    }
  }


  void setBacklineSetpoint(double setpoint) {
    _backlineSetpoint = setpoint.clamp(25.0, 300.0);
  }

  void setPCSetpoint(double setpoint) {
    _pcSetpoint = setpoint.clamp(0.1, 10.0);
  }


  void setHeaterSetpoint(String heater, double setpoint) {
    if (heater == 'h1') {
      _h1Setpoint = setpoint.clamp(25.0, 300.0);
    } else if (heater == 'h2') {
      _h2Setpoint = setpoint.clamp(25.0, 300.0);
    }
  }

  // Method to start continuous simulation
  Stream<void> startContinuousSimulation() async* {
    while (true) {
      simulateSystemBehavior();
      yield null;
      await Future.delayed(Duration(seconds: 1));
    }
  }
}