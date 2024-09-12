import 'dart:math';

class DataPoint {
  final DateTime time;
  final double value;

  DataPoint(this.time, this.value);
}

class DataVisualizationService {
  final Random _random = Random();
  final int _maxDataPoints = 100;

  List<DataPoint> generateTimeSeriesData(String parameter) {
    final now = DateTime.now();
    List<DataPoint> data = [];

    for (int i = 0; i < _maxDataPoints; i++) {
      final time = now.subtract(Duration(seconds: _maxDataPoints - i));
      double value;

      switch (parameter) {
        case 'Reactor Pressure':
          value = 1.0 + _random.nextDouble() * 0.5 - 0.25;
          break;
        case 'Reactor Temperature':
          value = 150.0 + _random.nextDouble() * 20 - 10;
          break;
        case 'Precursor A Temperature':
          value = 30.0 + _random.nextDouble() * 5 - 2.5;
          break;
        case 'Precursor B Temperature':
          value = 35.0 + _random.nextDouble() * 5 - 2.5;
          break;
        default:
          value = _random.nextDouble() * 100;
      }

      data.add(DataPoint(time, value));
    }

    return data;
  }

  Map<String, double> generatePieChartData() {
    return {
      'Precursor A': 30 + _random.nextDouble() * 10,
      'Precursor B': 35 + _random.nextDouble() * 10,
      'Purge': 20 + _random.nextDouble() * 5,
      'Pump Down': 15 + _random.nextDouble() * 5,
    };
  }

  List<Map<String, dynamic>> generateBarChartData() {
    final List<String> categories = ['Cycle 1', 'Cycle 2', 'Cycle 3', 'Cycle 4', 'Cycle 5'];
    List<Map<String, dynamic>> data = [];

    for (String category in categories) {
      data.add({
        'category': category,
        'Precursor A': 2 + _random.nextDouble() * 2,
        'Precursor B': 2 + _random.nextDouble() * 2,
        'Purge': 4 + _random.nextDouble() * 2,
      });
    }

    return data;
  }
}