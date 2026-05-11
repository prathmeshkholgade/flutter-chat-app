import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/core/theme/app_text_styles.dart';

class AppTheme {
  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      // fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor,
        surface: AppColors.white,
        onSurface: AppColors.black,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryColor,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        surface: AppColors.primaryColor,
        onSurface: AppColors.white,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.white),
        displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.white),
        displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.white),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
    );
  }

  /// Default theme (backward compatibility)
  static ThemeData get theme => darkTheme;
}
