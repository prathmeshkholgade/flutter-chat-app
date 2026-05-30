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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatController.getAllUsers();
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Users", style: Theme.of(context).textTheme.titleLarge),
        ),
        body: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutePaths.createGroupScreen);
                },
                child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.group_add_outlined),
                    SizedBox(width: 2.w),
                    Text(
                      "Create Group",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 16.sp),
                    ),
                  ],
                ),
              )),

              SizedBox(height: 2.h),

              Expanded(
                child: Obx(() {
                  if (chatController.isLoading.value &&
                      chatController.allUsers.isEmpty) {
                    return Center(child: LoadingHelper.loading());
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                        chatController.getAllUsers(fetchMore: true);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatController.allUsers.length,
                      itemBuilder: (context, index) {
                        final user = chatController.allUsers[index];

                        return _buildChatRow(context, user, () {
                          chatController.createDirectChatChannel(user.id);

                          Get.toNamed(
                            RoutePaths.chatDetailScreen,
                            arguments: {
                              "chatId": user.id,
                              "fullName": user.fullName,
                              "type": "direct",
                              "image": null,
                            },
                          );
                        });
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
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
