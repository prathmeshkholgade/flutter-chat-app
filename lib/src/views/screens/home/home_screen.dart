import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutePaths.allUsersScreen);
        },
        child: Icon(Icons.add),
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}

Widget _buildChatRow(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 7.h,
              width: 7.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.redColor,
              ),
              child: Center(
                child: Text(
                  "E",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emma Bailery",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  Text(
                    "Hey! Are we meeting today?",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 2.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "10:45 AM",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: 1.h),

                Container(
                  padding: EdgeInsets.all(1.2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.redColor,
                  ),
                  child: Text(
                    "2",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 1.5.h),

        Divider(color: AppColors.grey.withValues(alpha: 0.2), thickness: 1),
      ],
    ),
  );
}
