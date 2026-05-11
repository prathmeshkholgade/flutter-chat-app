import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final int maxLines;
  final int? maxLength;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,

    this.labelText,
    this.prefixIcon,
    this.suffixIcon,

    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,

    this.maxLines = 1,
    this.maxLength,

    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,

    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,

      maxLines: maxLines,
      maxLength: maxLength,

      keyboardType: keyboardType,
      textInputAction: textInputAction,

      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,

      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },

      style: TextStyle(fontSize: 15.sp, color: AppColors.black),

      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        counterText: "",

        filled: true,
        fillColor: AppColors.white,

        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),

        hintStyle: TextStyle(color: AppColors.grey, fontSize: 14.sp),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
