import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experiment_model.dart';
import 'experiment_detail_page.dart';

class ExperimentListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExperimentModel>(
      builder: (context, experimentModel, child) {
        final experiments = experimentModel.experiments;
        return ListView.builder(
          itemCount: experiments.length,
          itemBuilder: (context, index) {
            final experiment = experiments[index];
            return ExperimentListTile(experiment: experiment);
          },
        );
      },
    );
  }
}

class ExperimentListTile extends StatelessWidget {
  final Experiment experiment;

  const ExperimentListTile({Key? key, required this.experiment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(experiment.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${experiment.status.toString().split('.').last}'),
            Text('Start: ${_formatDate(experiment.startTime)}'),
            Text('End: ${_formatDate(experiment.endTime)}'),
          ],
        ),
        trailing: _buildStatusIcon(experiment.status),
        onTap: () => _navigateToExperimentDetail(context),
      ),
    );
  }

  Widget _buildStatusIcon(ExperimentStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case ExperimentStatus.planned:
        iconData = Icons.schedule;
        color = Colors.blue;
        break;
      case ExperimentStatus.inProgress:
        iconData = Icons.play_arrow;
        color = Colors.green;
        break;
      case ExperimentStatus.completed:
        iconData = Icons.check_circle;
        color = Colors.teal;
        break;
      case ExperimentStatus.cancelled:
        iconData = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Icon(iconData, color: color);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _navigateToExperimentDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExperimentDetailPage(experimentId: experiment.id),
      ),
    );
  }
}