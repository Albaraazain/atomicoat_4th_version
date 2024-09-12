import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      appBarTheme: AppBarTheme(
        color: AppColors.primaryColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.headerStyle,
        titleMedium: AppTextStyles.subheaderStyle,
        bodyMedium: AppTextStyles.bodyStyle,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.accentColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}