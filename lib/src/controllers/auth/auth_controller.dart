import 'package:flutter/material.dart';
import 'package:flutter_chat/core/utils/snackbar_helper.dart';
import 'package:flutter_chat/core/utils/storage_service.dart';
import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/services/api/auth/auth_service.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late AuthService _authService;
  AuthController({required ApiBaseClientService dioService})
    : _authService = AuthService(dioService: dioService);

  final _localStorageService = StorageService();
  final loingEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signupEmailController = TextEditingController();
  final fullNameController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      final password = loginPasswordController.text;
      final email = loingEmailController.text;
      if (password.isEmpty || email.isEmpty) {
        return SnackbarHelper.showError(message: "enter all details");
      }
      final res = await _authService.loginUser(
        email: email,
        password: password,
      );

      res.fold(
        (error) {
          return SnackbarHelper.showError(message: error.message.toString());
        },
        (success) {
          _localStorageService.saveToken(success.data!.token.toString());
          Get.offAllNamed(RoutePaths.bottomNav);
          return SnackbarHelper.showSuccess(
            message: "User logged in successfully",
          );
        },
      );
    } catch (e) {
      return SnackbarHelper.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signupUser() async {
    try {
      isLoading.value = true;
      final password = signupPasswordController.text;
      final email = signupEmailController.text;
      final fullName = signupEmailController.text;
      if (password.isEmpty || email.isEmpty || fullName.isEmpty) {
        return SnackbarHelper.showError(message: "enter all details");
      }
      final res = await _authService.signupUser(
        email: email,
        password: password,
        fullName: fullName,
      );
      res.fold(
        (error) {
          debugPrint("$error");
          return SnackbarHelper.showError(message: error.message.toString());
        },
        (success) {
          _localStorageService.saveToken(success.data!.token.toString());
          Get.offAllNamed(RoutePaths.bottomNav);
          return SnackbarHelper.showSuccess(
            message: "User signed up successfully",
          );
        },
      );
    } catch (e) {
      return SnackbarHelper.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
