import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experiment_model.dart';
import 'experiment_list_view.dart';
import 'experiment_calendar_view.dart';
import 'create_experiment_dialog.dart';

class ExperimentPlanningPage extends StatefulWidget {
  @override
  _ExperimentPlanningPageState createState() => _ExperimentPlanningPageState();
}

class _ExperimentPlanningPageState extends State<ExperimentPlanningPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experiment Planning and Scheduling'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'List View'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendar View'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateExperimentDialog(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExperimentListView(),
          ExperimentCalendarView(),
        ],
      ),
    );
  }

  void _showCreateExperimentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateExperimentDialog(),
    ).then((experiment) {
      if (experiment != null) {
        Provider.of<ExperimentModel>(context, listen: false).addExperiment(experiment);
      }
    });
  }
}