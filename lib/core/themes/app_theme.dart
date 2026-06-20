import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //-------------------Light Theme--------------------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
  );

  //-------------------Dark Theme--------------------------
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
  );
}
