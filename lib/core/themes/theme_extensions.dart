import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // PRIMARY
  Color get primary =>
      isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

  // SECONDARY
  Color get secondary =>
      isDarkMode ? AppColors.darkSecondry : AppColors.lightSecondry;

  // BACKGROUND
  Color get background =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  // TEXT
  Color get text => isDarkMode ? AppColors.darkText : AppColors.lightText;

  //HIT TEXT

  Color get hitText =>
      isDarkMode ? AppColors.darkHitText : AppColors.lightHitText;

  // COMMON

  Color get whiteText => AppColors.whiteText;
  
  Color get darkText => AppColors.blackText;

  Color get commanHitText => AppColors.commanHitText;

  Color get success => AppColors.success;

  Color get error => AppColors.error;
}
