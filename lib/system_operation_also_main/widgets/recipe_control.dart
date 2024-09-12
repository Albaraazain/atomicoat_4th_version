import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_state.dart';
import '../models/recipe.dart';

class RecipeControl extends StatelessWidget {
  final Function(Recipe) onStartRecipe;

  const RecipeControl({Key? key, required this.onStartRecipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeState>(
      builder: (context, recipeState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recipe Control',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                _buildRecipeSelector(context, recipeState),
                SizedBox(height: 16),
                _buildRecipeDetails(recipeState),
                SizedBox(height: 16),
                _buildRecipeControls(context, recipeState),
                if (recipeState.activeRecipe != null) ...[
                  SizedBox(height: 16),
                  _buildRecipeProgress(recipeState),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeSelector(BuildContext context, RecipeState recipeState) {
    return DropdownButton<String>(
      isExpanded: true,
      value: recipeState.selectedRecipe?.id,
      hint: Text('Select a recipe'),
      onChanged: (String? newValue) {
        if (newValue != null) {
          recipeState.selectRecipe(newValue);
        }
      },
      items: recipeState.recipes.map<DropdownMenuItem<String>>((Recipe recipe) {
        return DropdownMenuItem<String>(
          value: recipe.id,
          child: Text(recipe.name),
        );
      }).toList(),
    );
  }

  Widget _buildRecipeDetails(RecipeState recipeState) {
    if (recipeState.selectedRecipe == null) {
      return Text('No recipe selected');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recipe Details:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Name: ${recipeState.selectedRecipe!.name}'),
        Text('Steps: ${recipeState.selectedRecipe!.steps.length}'),
        SizedBox(height: 8),
        Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...recipeState.selectedRecipe!.steps.map((step) =>
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text('- ${step.type.toString().split('.').last}: ${_getStepDescription(step)}'),
            )
        ),
      ],
    );
  }

  String _getStepDescription(RecipeStep step) {
    switch (step.type) {
      case StepType.loop:
        return '${step.parameters['iterations']} iterations';
      case StepType.valve:
        return '${step.parameters['valveType'].toString().split('.').last} for ${step.parameters['duration']}s';
      case StepType.purge:
        return '${step.parameters['duration']}s';
      default:
        return 'Unknown step type';
    }
  }

  Widget _buildRecipeControls(BuildContext context, RecipeState recipeState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: recipeState.selectedRecipe != null && recipeState.activeRecipe == null
              ? () => onStartRecipe(recipeState.selectedRecipe!)
              : null,
          child: Text('Start Recipe'),
        ),
        ElevatedButton(
          onPressed: recipeState.activeRecipe != null
              ? () => recipeState.clearActiveRecipe()
              : null,
          child: Text('Stop Recipe'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _buildRecipeProgress(RecipeState recipeState) {
    // This is a placeholder. You'll need to implement the actual progress tracking in the RecipeState
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recipe Progress:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Active Recipe: ${recipeState.activeRecipe!.name}'),
        // Add more progress information here
      ],
    );
  }
}