import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/core/utils/helpers.dart';
import 'package:flutter_chat/core/utils/loading_helper.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/src/controllers/chat/chat_controller.dart';
import 'package:flutter_chat/src/models/chat/chat_users_response.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final chatController = Get.find<ChatController>();
  @override
  void initState() {
    super.initState();
    if (chatController.userChats.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatController.getChatsUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutePaths.allUsersScreen);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chats",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          if (chatController.isLoadingUserChats.value) {
            return Center(child: LoadingHelper.loading());
          }
          if (chatController.userChats.isEmpty) {
            return Center(
              child: Text(
                "No chats available",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                chatController.getChatsUser(isFetchMore: true);
              }
              return true;
            },
            child: ListView.builder(
              itemCount: chatController.userChats.length,
              itemBuilder: (context, index) {
                final user = chatController.userChats[index];
                return _buildChatRow(context, user, () {
                  Get.toNamed(
                    RoutePaths.chatDetailScreen,
                    arguments: {
                      "chatId": user.chatId,
                      "fullName": user.type == "direct"
                          ? (user.user?.fullName ?? "")
                          : (user.group?.name ?? ""),
                      "type": user.type,
                      "image": user.type == "direct"
                          ? user.user?.image
                          : user.group?.image,
                    },
                  );
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildChatRow(BuildContext context, ChatModel user, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    child: GestureDetector(
      onTap: onTap,
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
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://i.pinimg.com/1200x/4a/ca/fe/4acafecd9b6e8bf88b2b80b971e338eb.jpg",
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
                      user.type == "direct"
                          ? user.user?.fullName ?? ""
                          : user.group?.name ?? ",",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    SizedBox(height: 0.5.h),

                    Text(
                      user.lastMessage?.text ?? "No messages yet",
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
                    user.lastMessage != null
                        ? Helpers.formatChatTime(user.lastMessage!.createdAt)
                        : "",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // unread message count badge
                  // Container(
                  //   padding: EdgeInsets.all(1.2.w),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: AppColors.redColor,
                  //   ),
                  //   child: Text(
                  //     "2",
                  //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //       color: AppColors.white,
                  //       fontSize: 11.sp,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          Divider(color: AppColors.grey.withValues(alpha: 0.2), thickness: 1),
        ],
      ),
    ),
  );
}
