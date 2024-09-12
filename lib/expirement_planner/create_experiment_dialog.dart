import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'experiment_model.dart';

class CreateExperimentDialog extends StatefulWidget {
  @override
  _CreateExperimentDialogState createState() => _CreateExperimentDialogState();
}

class _CreateExperimentDialogState extends State<CreateExperimentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _objectivesController = TextEditingController();
  final _keyParametersController = TextEditingController();
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Experiment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Experiment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an experiment name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _objectivesController,
                decoration: InputDecoration(labelText: 'Objectives'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _keyParametersController,
                decoration: InputDecoration(labelText: 'Key Parameters (comma-separated)'),
              ),
              SizedBox(height: 16),
              _buildDateTimePicker(context, 'Start', _startDate, _startTime, (date, time) {
                setState(() {
                  _startDate = date;
                  _startTime = time;
                });
              }),
              SizedBox(height: 8),
              _buildDateTimePicker(context, 'End', _endDate, _endTime, (date, time) {
                setState(() {
                  _endDate = date;
                  _endTime = time;
                });
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Create'),
          onPressed: _createExperiment,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(
      BuildContext context,
      String label,
      DateTime date,
      TimeOfDay time,
      Function(DateTime, TimeOfDay) onChanged,
      ) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, date, (newDate) {
              onChanged(newDate, time);
            }),
            child: InputDecorator(
              decoration: InputDecoration(labelText: '$label Date'),
              child: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, time, (newTime) {
              onChanged(date, newTime);
            }),
            child: InputDecorator(
              decoration: InputDecoration(labelText: '$label Time'),
              child: Text('${time.format(context)}'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onSelect) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onSelect(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime, Function(TimeOfDay) onSelect) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      onSelect(picked);
    }
  }

  void _createExperiment() {
    if (_formKey.currentState!.validate()) {
      final experiment = Experiment(
        id: Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        objectives: _objectivesController.text,
        keyParameters: _keyParametersController.text.split(',').map((e) => e.trim()).toList(),
        steps: [],
        startTime: DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          _startTime.hour,
          _startTime.minute,
        ),
        endTime: DateTime(
          _endDate.year,
          _endDate.month,
          _endDate.day,
          _endTime.hour,
          _endTime.minute,
        ),
      );
      Navigator.of(context).pop(experiment);
    }
  }

}