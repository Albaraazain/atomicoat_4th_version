import 'package:flutter/foundation.dart';

class Recipe {
  String id;
  String name;
  List<RecipeStep> steps;
  String substrate;

  Recipe({
    required this.id,
    required this.name,
    required this.steps,
    required this.substrate,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      substrate: json['substrate'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'steps': steps.map((e) => e.toJson()).toList(),
    'substrate': substrate,
  };
}

class RecipeStep {
  StepType type;
  Map<String, dynamic> parameters;
  List<RecipeStep>? subSteps;

  RecipeStep({
    required this.type,
    required this.parameters,
    this.subSteps,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      type: StepType.values.firstWhere((e) => e.toString() == 'StepType.${json['type']}'),
      parameters: json['parameters'] as Map<String, dynamic>,
      subSteps: json['subSteps'] != null
          ? (json['subSteps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'parameters': parameters,
    'subSteps': subSteps?.map((e) => e.toJson()).toList(),
  };
}

enum StepType {
  loop,
  valve,
  purge,
}

enum ValveType {
  valveA,
  valveB,
}