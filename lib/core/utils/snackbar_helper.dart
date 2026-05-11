import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showSuccess({
    required String message,
    String title = 'Success',
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? AppColors.green,
      colorText: textColor ?? AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  static void showError({
    required String message,
    String title = 'Error',
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? AppColors.redColor,
      colorText: textColor ?? AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void showInfo({
    required String message,
    String title = 'Info',
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      colorText: textColor ?? AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }
}
