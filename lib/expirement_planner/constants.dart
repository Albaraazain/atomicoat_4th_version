import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF1976D2);
  static const accentColor = Color(0xFF03A9F4);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const textColor = Color(0xFF333333);
  static const errorColor = Color(0xFFD32F2F);
}

class AppTextStyles {
  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );
}

class AppStrings {
  static const appTitle = 'Experiment Planner';
  static const experimentListTitle = 'Experiments';
  static const calendarViewTitle = 'Calendar';
  static const addExperimentTitle = 'Add Experiment';
  static const editExperimentTitle = 'Edit Experiment';
  static const deleteExperimentConfirmation = 'Are you sure you want to delete this experiment?';
}