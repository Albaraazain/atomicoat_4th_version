import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/data_visualization_service.dart';

class DataVisualization extends StatefulWidget {
  @override
  _DataVisualizationState createState() => _DataVisualizationState();
}

class _DataVisualizationState extends State<DataVisualization> {
  final DataVisualizationService _dataService = DataVisualizationService();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildLineChart('Reactor Pressure'),
        _buildLineChart('Reactor Temperature'),
        _buildPieChart(),
        _buildBarChart(),
      ],
    );
  }

  Widget _buildLineChart(String parameter) {
    final data = _dataService.generateTimeSeriesData(parameter);
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.map((point) => FlSpot(point.time.millisecondsSinceEpoch.toDouble(), point.value)).toList(),
              isCurved: true,
              colors: [Theme.of(context).colorScheme.secondary],
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(showTitles: false),
            leftTitles: SideTitles(showTitles: true),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final data = _dataService.generatePieChartData();
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: data.entries.map((entry) => PieChartSectionData(
            value: entry.value,
            title: entry.key,
            color: Colors.primaries[data.keys.toList().indexOf(entry.key) % Colors.primaries.length],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final data = _dataService.generateBarChartData();
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) => data[value.toInt()]['category'],
            ),
          ),
          barGroups: List.generate(data.length, (index) {
            final item = data[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(y: item['Precursor A'], colors: [Colors.red]),
                BarChartRodData(y: item['Precursor B'], colors: [Colors.green]),
                BarChartRodData(y: item['Purge'], colors: [Colors.blue]),
              ],
            );
          }),
        ),
      ),
    );
  }
}