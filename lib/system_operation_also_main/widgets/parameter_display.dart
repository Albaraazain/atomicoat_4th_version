import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ald_system_provider.dart';

class ParameterDisplay extends StatefulWidget {
  @override
  _ParameterDisplayState createState() => _ParameterDisplayState();
}

class _ParameterDisplayState extends State<ParameterDisplay> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ALDSystemProvider>(
      builder: (context, aldSystem, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Parameters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Parameters',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildExpandableSection('N2 Generator', [
                        _buildParameterRow('Status', aldSystem.n2GenActive ? 'Active' : 'Inactive'),
                        _buildParameterRow('Flow Rate', '${aldSystem.n2Flow.toStringAsFixed(2)} sccm'),
                      ]),
                      _buildExpandableSection('Mass Flow Controller', [
                        _buildParameterRow('Setpoint', '${aldSystem.mfcSetpoint.toStringAsFixed(2)} sccm'),
                        _buildParameterRow('Actual Flow', '${aldSystem.mfcActualFlow.toStringAsFixed(2)} sccm'),
                      ]),
                      _buildExpandableSection('Frontline Heater', [
                        _buildParameterRow('Status', aldSystem.frontlineHeaterActive ? 'Active' : 'Inactive'),
                        _buildParameterRow('Temperature', '${aldSystem.frontlineTemperature.toStringAsFixed(1)}°C'),
                        _buildParameterRow('Setpoint', '${aldSystem.frontlineSetpoint.toStringAsFixed(1)}°C'),
                      ]),
                      _buildExpandableSection('Chamber', [
                        _buildParameterRow('Pressure', '${aldSystem.chamberPressure.toStringAsFixed(3)} Torr'),
                        _buildParameterRow('Temperature', '${aldSystem.chamberTemperature.toStringAsFixed(1)}°C'),
                      ]),
                      _buildExpandableSection('Backline Heater', [
                        _buildParameterRow('Status', aldSystem.backlineHeaterActive ? 'Active' : 'Inactive'),
                        _buildParameterRow('Temperature', '${aldSystem.backlineTemperature.toStringAsFixed(1)}°C'),
                        _buildParameterRow('Setpoint', '${aldSystem.backlineSetpoint.toStringAsFixed(1)}°C'),
                      ]),
                      _buildExpandableSection('Pressure Controller', [
                        _buildParameterRow('Setpoint', '${aldSystem.pcSetpoint.toStringAsFixed(3)} Torr'),
                        _buildParameterRow('Actual Pressure', '${aldSystem.pcActualPressure.toStringAsFixed(3)} Torr'),
                      ]),
                      _buildExpandableSection('Pump', [
                        _buildParameterRow('Status', aldSystem.pumpActive ? 'Active' : 'Inactive'),
                      ]),
                      _buildExpandableSection('Valves', [
                        _buildParameterRow('V1', aldSystem.v1Open ? 'Open' : 'Closed'),
                        _buildParameterRow('V2', aldSystem.v2Open ? 'Open' : 'Closed'),
                      ]),
                      _buildExpandableSection('Heaters', [
                        _buildParameterRow('H1 Status', aldSystem.h1Active ? 'Active' : 'Inactive'),
                        _buildParameterRow('H1 Temperature', '${aldSystem.h1Temperature.toStringAsFixed(1)}°C'),
                        _buildParameterRow('H1 Setpoint', '${aldSystem.h1Setpoint.toStringAsFixed(1)}°C'),
                        _buildParameterRow('H2 Status', aldSystem.h2Active ? 'Active' : 'Inactive'),
                        _buildParameterRow('H2 Temperature', '${aldSystem.h2Temperature.toStringAsFixed(1)}°C'),
                        _buildParameterRow('H2 Setpoint', '${aldSystem.h2Setpoint.toStringAsFixed(1)}°C'),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection(String title, List<Widget> rows) {
    bool isExpanded = _searchQuery.isEmpty || title.toLowerCase().contains(_searchQuery) ||
        rows.any((row) => (row as _ParameterRow).label.toLowerCase().contains(_searchQuery) ||
            (row as _ParameterRow).value.toLowerCase().contains(_searchQuery));

    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: isExpanded,
      children: rows,
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return _ParameterRow(
      label: label,
      value: value,
      isVisible: _searchQuery.isEmpty ||
          label.toLowerCase().contains(_searchQuery) ||
          value.toLowerCase().contains(_searchQuery),
    );
  }
}

class _ParameterRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isVisible;

  const _ParameterRow({
    Key? key,
    required this.label,
    required this.value,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(color: _getValueColor(value)),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getValueColor(String value) {
    if (value == 'Active' || value == 'Open') {
      return Colors.green;
    } else if (value == 'Inactive' || value == 'Closed') {
      return Colors.red;
    }
    // Add more color logic for numerical values if needed
    return Colors.black;
  }
}