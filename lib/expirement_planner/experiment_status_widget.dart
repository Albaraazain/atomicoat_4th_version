import 'package:flutter/material.dart';
import 'experiment_model.dart';
import 'constants.dart';

class ExperimentStatusWidget extends StatelessWidget {
  final ExperimentStatus status;

  const ExperimentStatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), color: _getStatusColor(), size: 16),
          SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: TextStyle(color: _getStatusColor(), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case ExperimentStatus.planned:
        return Colors.blue;
      case ExperimentStatus.inProgress:
        return Colors.green;
      case ExperimentStatus.completed:
        return Colors.teal;
      case ExperimentStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case ExperimentStatus.planned:
        return Icons.schedule;
      case ExperimentStatus.inProgress:
        return Icons.play_arrow;
      case ExperimentStatus.completed:
        return Icons.check_circle;
      case ExperimentStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText() {
    return status.toString().split('.').last;
  }
}