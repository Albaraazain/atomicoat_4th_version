import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ald_system_provider.dart';
import '../providers/recipe_provider.dart' as provider;
import '../providers/alarm_provider.dart';
import '../widgets/parameter_display.dart';
import '../widgets/recipe_control.dart';
import '../widgets/alarm_display.dart';
import '../widgets/data_visualization.dart';
import '../widgets/system_diagram.dart';
import 'recipe_management_screen.dart';
import '../models/recipe.dart' as model;

class MainDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ALD Process Monitor'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
              Tab(icon: Icon(Icons.science), text: 'Recipe Control'),
              Tab(icon: Icon(Icons.warning), text: 'Alarms'),
              Tab(icon: Icon(Icons.analytics), text: 'Data'),
            ],
          ),
        ),
        drawer: _buildDrawer(context),
        body: TabBarView(
          children: [
            _buildOverviewTab(context),
            _buildRecipeControlTab(context),
            AlarmDisplay(),
            DataVisualization(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.stop),
          backgroundColor: Colors.red,
          onPressed: () => _handleEmergencyStop(context),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'ALD Process Monitor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Recipe Management'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeManagementScreen()),
              );
            },
          ),
          // Add more drawer items here as needed
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SystemDiagram(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ParameterDisplay(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeControlTab(BuildContext context) {
    return RecipeControl(
      onStartRecipe: (model.Recipe recipe) {
        final aldSystemProvider = Provider.of<ALDSystemProvider>(context, listen: false);
        final recipeProvider = Provider.of<provider.RecipeProvider>(context, listen: false);
        recipeProvider.startRecipe(
              (parameters) => aldSystemProvider.handleRecipeStep(parameters),
        );
      },
    );
  }

  void _handleEmergencyStop(BuildContext context) {
    Provider.of<ALDSystemProvider>(context, listen: false).emergencyStop();
    Provider.of<provider.RecipeProvider>(context, listen: false).stopRecipe();
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
  }
}