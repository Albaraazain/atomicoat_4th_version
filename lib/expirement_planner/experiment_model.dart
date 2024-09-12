import 'package:flutter/foundation.dart';

class Experiment {
  final String id;
  String name;
  String description;
  String objectives;
  List<String> keyParameters;
  List<ExperimentStep> steps;
  DateTime startTime;
  DateTime endTime;
  ExperimentStatus status;
  List<String> teamMemberIds;
  List<String> attachmentUrls;

  Experiment({
    required this.id,
    required this.name,
    required this.description,
    required this.objectives,
    required this.keyParameters,
    required this.steps,
    required this.startTime,
    required this.endTime,
    this.status = ExperimentStatus.planned,
    this.teamMemberIds = const [],
    this.attachmentUrls = const [],
  });
}

class ExperimentStep {
  String description;
  bool isCompleted;

  ExperimentStep({
    required this.description,
    this.isCompleted = false,
  });
}

enum ExperimentStatus {
  planned,
  inProgress,
  completed,
  cancelled,
}

class ExperimentModel extends ChangeNotifier {
  List<Experiment> _experiments = [];

  List<Experiment> get experiments => _experiments;

  void addExperiment(Experiment experiment) {
    _experiments.add(experiment);
    notifyListeners();
  }

  void updateExperiment(Experiment updatedExperiment) {
    final index = _experiments.indexWhere((e) => e.id == updatedExperiment.id);
    if (index != -1) {
      _experiments[index] = updatedExperiment;
      notifyListeners();
    }
  }

  void deleteExperiment(String experimentId) {
    _experiments.removeWhere((e) => e.id == experimentId);
    notifyListeners();
  }

  Experiment? getExperimentById(String id) {
    return _experiments.firstWhere((e) => e.id == id);
  }

  List<Experiment> getExperimentsByStatus(ExperimentStatus status) {
    return _experiments.where((e) => e.status == status).toList();
  }

  List<Experiment> getExperimentsByDateRange(DateTime start, DateTime end) {
    return _experiments.where((e) =>
    (e.startTime.isAfter(start) || e.startTime.isAtSameMomentAs(start)) &&
        (e.endTime.isBefore(end) || e.endTime.isAtSameMomentAs(end))
    ).toList();
  }

  void updateExperimentStatus(String experimentId, ExperimentStatus newStatus) {
    final experiment = getExperimentById(experimentId);
    if (experiment != null) {
      experiment.status = newStatus;
      notifyListeners();
    }
  }

  void addTeamMemberToExperiment(String experimentId, String teamMemberId) {
    final experiment = getExperimentById(experimentId);
    if (experiment != null && !experiment.teamMemberIds.contains(teamMemberId)) {
      experiment.teamMemberIds.add(teamMemberId);
      notifyListeners();
    }
  }

  void removeTeamMemberFromExperiment(String experimentId, String teamMemberId) {
    final experiment = getExperimentById(experimentId);
    if (experiment != null) {
      experiment.teamMemberIds.remove(teamMemberId);
      notifyListeners();
    }
  }

  void addAttachmentToExperiment(String experimentId, String attachmentUrl) {
    final experiment = getExperimentById(experimentId);
    if (experiment != null) {
      experiment.attachmentUrls.add(attachmentUrl);
      notifyListeners();
    }
  }

  void removeAttachmentFromExperiment(String experimentId, String attachmentUrl) {
    final experiment = getExperimentById(experimentId);
    if (experiment != null) {
      experiment.attachmentUrls.remove(attachmentUrl);
      notifyListeners();
    }
  }
}