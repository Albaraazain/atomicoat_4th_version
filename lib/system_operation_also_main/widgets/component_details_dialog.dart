import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ald_system_provider.dart';

class ComponentDetailsDialog extends StatelessWidget {
  final String componentId;

  const ComponentDetailsDialog({Key? key, required this.componentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ALDSystemProvider>(
      builder: (context, aldSystem, child) {
        return AlertDialog(
          title: Text(_getComponentName(componentId)),
          content: SingleChildScrollView(
            child: _buildComponentDetails(componentId, aldSystem, context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getComponentName(String componentId) {
    switch (componentId) {
      case 'n2gen': return 'N2 Generator';
      case 'mfc': return 'Mass Flow Controller';
      case 'frontline_heater': return 'Frontline Heater';
      case 'chamber': return 'Chamber';
      case 'backline_heater': return 'Backline Heater';
      case 'pc': return 'Pressure Controller';
      case 'pump': return 'Pump';
      case 'v1': return 'Valve 1';
      case 'v2': return 'Valve 2';
      case 'h1': return 'Heater 1';
      case 'h2': return 'Heater 2';
      default: return 'Unknown Component';
    }
  }

  Widget _buildComponentDetails(String componentId, ALDSystemProvider aldSystem, BuildContext context) {
    switch (componentId) {
      case 'n2gen':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Status: ${aldSystem.n2GenActive ? "Active" : "Inactive"}'),
            Text('Flow Rate: ${aldSystem.n2Flow.toStringAsFixed(2)} sccm'),
            ElevatedButton(
              onPressed: () => aldSystem.toggleN2Gen(),
              child: Text(aldSystem.n2GenActive ? 'Turn Off' : 'Turn On'),
            ),
          ],
        );
      case 'mfc':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Setpoint: ${aldSystem.mfcSetpoint.toStringAsFixed(2)} sccm'),
            Text('Actual Flow: ${aldSystem.mfcActualFlow.toStringAsFixed(2)} sccm'),
            TextField(
              decoration: InputDecoration(labelText: 'Set Flow Rate (sccm)'),
              keyboardType: TextInputType.number,
              onSubmitted: (value) => aldSystem.setMFCSetpoint(double.parse(value)),
            ),
          ],
        );
    // Add cases for other components here...
      default:
        return Text('No details available for this component.');
    }
  }
}