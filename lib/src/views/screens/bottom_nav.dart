import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_assets.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/src/views/screens/home/home_screen.dart';
import 'package:flutter_chat/src/views/screens/notification/notification_screen.dart';
import 'package:flutter_chat/src/views/screens/profile/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  DateTime? lastPressedAt;

  void changeScreen(int index) {
    currentIndex.value = index;
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final BottomNavController controller;

  BottomNav({super.key, this.currentIndex = 0})
    : controller = Get.find<BottomNavController>() {
    controller.currentIndex.value = currentIndex;
  }

  final screens = [HomeScreen(), NotificationScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: SafeArea(child: _buildBottomNavBar(context)),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.black.withValues(alpha: 0.1)),
                ),
              ),
            ),
          ),

          // Nav items
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, AppAssets.chat, 'Chat'),
                _buildNavItem(1, AppAssets.notification, 'Notification'),
                _buildNavItem(2, AppAssets.person, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeScreen(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Small line on top when selected
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              SvgPicture.asset(
                iconPath,
                height: 28,
                width: 28,
                // ignore: deprecated_member_use
                color: isSelected ? AppColors.primaryColor : AppColors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : AppColors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
