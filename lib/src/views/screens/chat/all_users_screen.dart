import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/core/utils/loading_helper.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/src/controllers/chat/chat_controller.dart';
import 'package:flutter_chat/src/models/chat/all_users_response_model.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:sizer/sizer.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final chatController = Get.find<ChatController>();
  @override
  void initState() {
    super.initState();
    if (chatController.allUsers.isEmpty) {
      chatController.getAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Users", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          if (chatController.isLoading.value) {
            return Center(child: LoadingHelper.loading());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                chatController.getAllUsers(fetchMore: true);
              }
              return true;
            },
            child: ListView.builder(
              itemCount: chatController.allUsers.length,
              itemBuilder: (context, index) {
                final user = chatController.allUsers[index];
                return _buildChatRow(context, user, () {
                  chatController.createDirectChatChannel(user.id);
                  Get.toNamed(RoutePaths.chatDetailScreen);
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildChatRow(
  BuildContext context,
  ChatUserModel user,
  VoidCallback onTap,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey,
                ),
                child: ClipOval(
                  child: Image.network(
                    "https://i.pinimg.com/736x/3c/2b/ad/3c2badd0b9688bcb810ef699afc3f7c1.jpg",
                    fit: BoxFit.cover,
                    alignment: AlignmentGeometry.topCenter,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              Expanded(
                child: Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.grey.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    ),
  );
}
