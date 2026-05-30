import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constant/app_colors.dart';
import 'package:flutter_chat/core/utils/app_logger.dart';
import 'package:flutter_chat/core/utils/loading_helper.dart';
import 'package:flutter_chat/core/utils/storage_service.dart';
import 'package:flutter_chat/services/api/chat/socket_service.dart';
import 'package:flutter_chat/src/controllers/chat/chat_controller.dart';
import 'package:flutter_chat/src/models/chat/all_users_response_model.dart';
import 'package:flutter_chat/src/models/chat/chat_messages_data.dart';
import 'package:flutter_chat/src/models/chat/chat_users_response.dart';
import 'package:flutter_chat/src/views/widgets/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final chatController = Get.find<ChatController>();
  final SocketService _socketService = SocketService();
  final ScrollController _scrollController = ScrollController();
  final args = Get.arguments;

  @override
  void initState() {
    super.initState();
    chatController.getCurrentUserId();
    chatController.chatMessages.clear();
    final int chatId = args["chatId"] as int;
    chatController.getChatMessages(chatId: chatId);
    _socketService.joinRoom(chatId.toString());

    _listenForMessages();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    chatController.chatMessages.clear();
    super.dispose();
  }

  void _listenForMessages() {
    _socketService.onMessageReceive((data) {
      AppLogger.i("Message received: $data");
      // if (int.tryParse(data["senderId"].toString()) ==
      //     int.tryParse(chatController.currentUserId.toString())) {
      //   return;
      // }
      chatController.chatMessages.add(
        ChatMessageModel(
          chatId: data["chatId"],
          type: data["type"],
          id: data["id"],
          senderId: data["senderId"],
          text: data["text"],
          createdAt: DateTime.parse(data["createdAt"]),
          updatedAt: DateTime.parse(data["updatedAt"]),
          fileUrl: data["fileUrl"] ?? "",
        ),
      );
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    final int chatId = args["chatId"] as int;
    final text = chatController.messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    _socketService.sendMessage(
      chatId: chatId,
      senderId: int.parse(chatController.currentUserId.toString()),
      message: text,
    );
    chatController.messageController.clear();
    chatController.chatMessages.add(
      ChatMessageModel(
        chatId: chatId,
        type: "text",
        id: DateTime.now().millisecondsSinceEpoch,
        senderId: int.parse(chatController.currentUserId.toString()),
        text: text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fileUrl: "",
      ),
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.d("currentUserId: ${chatController.currentUserId}");
    final String fullName = args["fullName"] ?? "Chat";
    final String chatType = args["type"] ?? "direct";
    final String? chatImage = args["image"];
    final int? memberCount = args["memberCount"];

    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 2.3.h,
              backgroundColor: AppColors.grey.withValues(alpha: 0.15),
              backgroundImage: chatImage != null && chatImage.isNotEmpty
                  ? NetworkImage(chatImage)
                  : null,
              child: chatImage == null || chatImage.isEmpty
                  ? Icon(
                      chatType == "group" ? Icons.group_rounded : Icons.person_rounded,
                      color: const Color(0xFF0F52BA),
                      size: 2.6.h,
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (chatType == "group")
                    Text(
                      memberCount != null ? "$memberCount members" : "group chat",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.isLoadingChatMessage.value) {
                return Center(child: LoadingHelper.loading());
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    // chatController.getChatMessages(
                    //   chatId: user.chatId,
                    //   isFetchMore: true,
                    // );
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: chatController.chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.chatMessages[index];
                    return ChatBubble(
                      message: message.text,
                      isOwner:
                          message.senderId ==
                          int.parse(chatController.currentUserId.toString()),
                    );
                  },
                ),
              );
            }),
          ),
          _ChatInput(
            controller: chatController.messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 1.h),
        color: const Color(0xFFECE5DD),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Message",
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.4.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              height: 6.h,
              width: 6.h,
              child: FloatingActionButton(
                elevation: 1,
                backgroundColor: AppColors.green,
                onPressed: onSend,
                child: Icon(Icons.send, color: AppColors.white, size: 2.7.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
