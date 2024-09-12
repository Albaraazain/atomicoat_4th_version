import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experiment_list_view.dart';
import 'experiment_model.dart';
import 'experiment_planning_page.dart';
import 'experiment_calendar_view.dart';
import 'app_theme.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExperimentModel()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Text(
                AppStrings.appTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(AppStrings.experimentListTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExperimentPlanningPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(AppStrings.calendarViewTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExperimentCalendarView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to ${AppStrings.appTitle}!', style: AppTextStyles.headerStyle),
      ),
    );
  }
}

class ExperimentPlanningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.experimentListTitle),
      ),
      body: Consumer<ExperimentModel>(
        builder: (context, experimentModel, child) {
          if (experimentModel.experiments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No experiments yet.', style: AppTextStyles.subheaderStyle),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Add Experiment'),
                    onPressed: () => _showCreateExperimentDialog(context),
                  ),
                ],
              ),
            );
          } else {
            return ExperimentListView();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateExperimentDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Experiment',
      ),
    );
  }

  void _showCreateExperimentDialog(BuildContext context) {
    // For testing purposes, we'll just add a dummy experiment
    final experiment = Experiment(
      id: DateTime.now().toString(),
      name: 'Test Experiment ${DateTime.now().millisecondsSinceEpoch}',
      description: 'This is a test experiment',
      objectives: 'Test objectives',
      keyParameters: ['Param1', 'Param2'],
      steps: [ExperimentStep(description: 'Step 1'), ExperimentStep(description: 'Step 2')],
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
    );
    Provider.of<ExperimentModel>(context, listen: false).addExperiment(experiment);
  }
}