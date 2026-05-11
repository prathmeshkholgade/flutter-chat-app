import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_assets.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/services/routes/routes.dart';
import 'package:flutter_chat/src/controllers/auth/auth_controller.dart';
import 'package:flutter_chat/src/views/widgets/app_button.dart';
import 'package:flutter_chat/src/views/widgets/custom_text_field.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Center(
              child: Container(
                alignment: Alignment.center,
                width: 80.w,
                child: Image.asset(AppAssets.chatIllustration, height: 300),
              ),
            ),
            Text(
              "Sign In",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'Enter your email and password to continue',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 2.h),

            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "email is required";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    hintText: "Email",
                    controller: authController.loingEmailController,
                  ),
                  SizedBox(height: 2.h),
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "password is required";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock_person_outlined),
                    hintText: "Password",
                    obscureText: true,
                    controller: authController.loginPasswordController,
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: AlignmentGeometry.topRight,
                    child: Text(
                      "Forget Password",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Obx(
                    () => AppButton(
                      isLoading: authController.isLoading.value,
                      title: "Sign In",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          authController.loginUser();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    "---- Or Continue With ----",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppColors.grey),
                  ),
                  SizedBox(height: 2.h),
                  AppButton(
                    title: "Google",
                    isOutlined: true,
                    borderColor: AppColors.grey,
                    textColor: AppColors.grey,
                    backgroundColor: AppColors.white,
                    onPressed: () {},
                  ),
                  SizedBox(height: 2.h),

                  RichText(
                    text: TextSpan(
                      text: "Haven't have any account? ",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(RoutePaths.signupScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
