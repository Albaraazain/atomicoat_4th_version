import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experiment_model.dart';

class ExperimentDetailPage extends StatefulWidget {
  final String experimentId;

  ExperimentDetailPage({required this.experimentId});

  @override
  _ExperimentDetailPageState createState() => _ExperimentDetailPageState();
}

class _ExperimentDetailPageState extends State<ExperimentDetailPage> {
  late Experiment _experiment;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _objectivesController;
  late TextEditingController _keyParametersController;

  @override
  void initState() {
    super.initState();
    _experiment = Provider.of<ExperimentModel>(context, listen: false)
        .getExperimentById(widget.experimentId)!;
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: _experiment.name);
    _descriptionController = TextEditingController(text: _experiment.description);
    _objectivesController = TextEditingController(text: _experiment.objectives);
    _keyParametersController = TextEditingController(text: _experiment.keyParameters.join(', '));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Experiment' : 'Experiment Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', _nameController, enabled: _isEditing),
              _buildTextField('Description', _descriptionController, maxLines: 3, enabled: _isEditing),
              _buildTextField('Objectives', _objectivesController, maxLines: 2, enabled: _isEditing),
              _buildTextField('Key Parameters', _keyParametersController, enabled: _isEditing),
              SizedBox(height: 16),
              _buildDateTimeField('Start', _experiment.startTime),
              _buildDateTimeField('End', _experiment.endTime),
              SizedBox(height: 16),
              Text('Status: ${_experiment.status.toString().split('.').last}'),
              SizedBox(height: 16),
              Text('Steps:', style: Theme.of(context).textTheme.titleLarge),
              ..._buildStepsList(),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Add Step'),
                onPressed: _isEditing ? _addStep : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        enabled: enabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateTimeField(String label, DateTime dateTime) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.titleMedium),
          Text('${_formatDateTime(dateTime)}'),
        ],
      ),
    );
  }

  List<Widget> _buildStepsList() {
    return _experiment.steps.asMap().entries.map((entry) {
      int index = entry.key;
      ExperimentStep step = entry.value;
      return ListTile(
        title: Text(step.description),
        leading: Checkbox(
          value: step.isCompleted,
          onChanged: _isEditing ? (bool? value) {
            setState(() {
              _experiment.steps[index].isCompleted = value!;
            });
          } : null,
        ),
        trailing: _isEditing ? IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteStep(index),
        ) : null,
      );
    }).toList();
  }

  void _toggleEditing() {
    if (_isEditing) {
      if (_formKey.currentState!.validate()) {
        _saveChanges();
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    _experiment.name = _nameController.text;
    _experiment.description = _descriptionController.text;
    _experiment.objectives = _objectivesController.text;
    _experiment.keyParameters = _keyParametersController.text.split(',').map((e) => e.trim()).toList();

    Provider.of<ExperimentModel>(context, listen: false).updateExperiment(_experiment);
  }

  void _addStep() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newStep = '';
        return AlertDialog(
          title: Text('Add New Step'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter step description'),
            onChanged: (value) {
              newStep = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _experiment.steps.add(ExperimentStep(description: newStep));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteStep(int index) {
    setState(() {
      _experiment.steps.removeAt(index);
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _objectivesController.dispose();
    _keyParametersController.dispose();
    super.dispose();
  }
}