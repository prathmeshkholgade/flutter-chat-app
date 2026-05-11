import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_assets.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/src/controllers/auth/auth_controller.dart';
import 'package:flutter_chat/src/views/widgets/app_button.dart';
import 'package:flutter_chat/src/views/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                child: Image.asset(AppAssets.signupIllustration, height: 300),
              ),
            ),
            Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'Use proper information to continue',
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
                        return "fullName is required";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    hintText: "FullName",
                    controller: authController.fullNameController,
                  ),
                  SizedBox(height: 2.h),

                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "email is required";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    hintText: "Email",
                    controller: authController.signupEmailController,
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
                    controller: authController.signupPasswordController,
                  ),
                  SizedBox(height: 2.h),

                  Obx(
                    () => AppButton(
                      isLoading: authController.isLoading.value,
                      title: "Sign Up",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          authController.signupUser();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),

                  RichText(
                    text: TextSpan(
                      text: "Already have an Account? Sign in ",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.back();
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
