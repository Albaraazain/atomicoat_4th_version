import '../providers/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ald_system_provider.dart';
import '../providers/alarm_provider.dart';
import '../widgets/parameter_display.dart';
import '../widgets/recipe_control.dart';
import '../widgets/alarm_display.dart';
import '../widgets/data_visualization.dart';
import '../widgets/system_diagram.dart';
import '../widgets/component_details_dialog.dart';


class MainDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALD Process Monitor'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Help'),
                    content: Text('This is the ALD Process Monitor. Click on components in the system diagram for detailed information and controls.'),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SystemDiagram(
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: ParameterDisplay(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: RecipeControl(onStartRecipe: (Recipe ) {  },),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: AlarmDisplay(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: DataVisualization(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.stop),
        backgroundColor: Colors.red,
        onPressed: () {
          // Implement emergency stop functionality
          Provider.of<ALDSystemProvider>(context, listen: false).emergencyStop();
          Provider.of<RecipeProvider>(context, listen: false).stopRecipe();
          Provider.of<AlarmProvider>(context, listen: false).addAlarm(
            'Emergency stop activated',
            AlarmSeverity.critical,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Emergency Stop Activated!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        },
      ),
    );
  }
}