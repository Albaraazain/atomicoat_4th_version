import 'dart:async';
import 'package:flutter/foundation.dart';

class RecipeStep {
  final String name;
  final Map<String, dynamic> parameters;
  final Duration duration;

  RecipeStep({required this.name, required this.parameters, required this.duration});
}

class Recipe {
  final String name;
  final List<RecipeStep> steps;

  Recipe({required this.name, required this.steps});
}

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  Recipe? _selectedRecipe;
  Recipe? _activeRecipe;
  int _currentStepIndex = -1;
  bool _isRunning = false;
  Timer? _recipeTimer;

  List<Recipe> get recipes => _recipes;
  Recipe? get selectedRecipe => _selectedRecipe;
  Recipe? get activeRecipe => _activeRecipe;
  int get currentStepIndex => _currentStepIndex;
  bool get isRunning => _isRunning;

  RecipeProvider() {
    _loadSampleRecipes();
  }

  void _loadSampleRecipes() {
    _recipes = [
      Recipe(
        name: 'Sample ALD Recipe',
        steps: [
          RecipeStep(
            name: 'Precursor A Pulse',
            parameters: {'v1': true, 'frontline_heater': true},
            duration: Duration(seconds: 5),
          ),
          RecipeStep(
            name: 'Purge',
            parameters: {'v1': false, 'purge_valve': true},
            duration: Duration(seconds: 10),
          ),
          RecipeStep(
            name: 'Precursor B Pulse',
            parameters: {'v2': true, 'backline_heater': true},
            duration: Duration(seconds: 5),
          ),
          RecipeStep(
            name: 'Purge',
            parameters: {'v2': false, 'purge_valve': true},
            duration: Duration(seconds: 10),
          ),
        ],
      ),
    ];
  }

  void selectRecipe(Recipe recipe) {
    _selectedRecipe = recipe;
    notifyListeners();
  }

  void startRecipe(Function(Map<String, dynamic>) onStepChange) {
    if (_selectedRecipe != null && !_isRunning) {
      _activeRecipe = _selectedRecipe;
      _currentStepIndex = 0;
      _isRunning = true;
      _executeCurrentStep(onStepChange);
      notifyListeners();
    }
  }

  void stopRecipe() {
    _recipeTimer?.cancel();
    _isRunning = false;
    _activeRecipe = null;
    _currentStepIndex = -1;
    notifyListeners();
  }

  void _executeCurrentStep(Function(Map<String, dynamic>) onStepChange) {
    if (_activeRecipe == null || _currentStepIndex >= _activeRecipe!.steps.length) {
      stopRecipe();
      return;
    }

    RecipeStep currentStep = _activeRecipe!.steps[_currentStepIndex];
    onStepChange(currentStep.parameters);

    _recipeTimer = Timer(currentStep.duration, () {
      _currentStepIndex++;
      _executeCurrentStep(onStepChange);
      notifyListeners();
    });
  }

  // Method to add a new recipe
  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  // Method to remove a recipe
  void removeRecipe(Recipe recipe) {
    _recipes.remove(recipe);
    if (_selectedRecipe == recipe) {
      _selectedRecipe = null;
    }
    notifyListeners();
  }

  // Method to edit an existing recipe
  void editRecipe(Recipe oldRecipe, Recipe newRecipe) {
    int index = _recipes.indexOf(oldRecipe);
    if (index != -1) {
      _recipes[index] = newRecipe;
      if (_selectedRecipe == oldRecipe) {
        _selectedRecipe = newRecipe;
      }
      notifyListeners();
    }
  }
}