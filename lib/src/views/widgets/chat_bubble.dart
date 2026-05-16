import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:sizer/sizer.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isOwner,
    this.time,
  });

  final String message;
  final bool isOwner;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 78.w),
        child: Container(
          margin: EdgeInsets.only(
            left: isOwner ? 12.w : 0,
            right: isOwner ? 0 : 12.w,
            bottom: 1.2.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
          decoration: BoxDecoration(
            color: isOwner
                ? AppColors.primaryColor.withValues(alpha: 0.95)
                : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isOwner ? 16 : 4),
              bottomRight: Radius.circular(isOwner ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isOwner ? AppColors.white : AppColors.black,
                  fontSize: 15.sp,
                  height: 1.25,
                ),
              ),
              if (time != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  time!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isOwner
                        ? AppColors.white.withValues(alpha: 0.75)
                        : AppColors.grey,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
