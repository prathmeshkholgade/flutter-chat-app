import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? textColor;

  final double? height;
  final double? width;

  final double? borderRadius;
  final double? fontSize;

  final Widget? child;

  final bool isLoading;
  final bool isOutlined;

  final Color? borderColor;
  final double? borderWidth;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,

    this.backgroundColor,
    this.textColor,

    this.height,
    this.width,

    this.borderRadius,
    this.fontSize,

    this.child,

    this.isLoading = false,
    this.isOutlined = false,

    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 6.h,
      width: width ?? double.infinity,

      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: isOutlined
              ? Colors.transparent
              : backgroundColor ?? AppColors.primaryColor,

          shadowColor: Colors.transparent,

          side: isOutlined
              ? BorderSide(
                  color: borderColor ?? AppColors.primaryColor,
                  width: borderWidth ?? 1,
                )
              : null,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? 12,
            ),
          ),
        ),

        child: isLoading
            ? SizedBox(
                height: 2.2.h,
                width: 2.2.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isOutlined
                      ? AppColors.primaryColor
                      : AppColors.white,
                ),
              )
            : child ??
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize ?? 15.sp,
                    fontWeight: FontWeight.w600,

                    color: isOutlined
                        ? textColor ?? AppColors.primaryColor
                        : textColor ?? AppColors.white,
                  ),
                ),
      ),
    );
  }
}