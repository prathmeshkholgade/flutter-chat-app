import 'package:flutter/material.dart';
import 'package:flutter_chat/core/utils/snackbar_helper.dart';
import 'package:flutter_chat/core/utils/storage_service.dart';
import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/services/api/chat/chat_service.dart';
import 'package:flutter_chat/services/api/chat/socket_service.dart';
import 'package:flutter_chat/src/models/chat/all_users_response_model.dart';
import 'package:flutter_chat/src/models/chat/chat_messages_data.dart';
import 'package:flutter_chat/src/models/chat/chat_users_response.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late ChatService _chatService;
  ChatController({required ApiBaseClientService dioService})
    : _chatService = ChatService(dioService: dioService);

  final TextEditingController messageController = TextEditingController();
  final SocketService _socketService = SocketService();
  final RxList<ChatUserModel> allUsers = RxList<ChatUserModel>();

  // Group creation state and logic
  final groupFormKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  
  final RxInt groupNameLength = 0.obs;
  final RxInt groupDescriptionLength = 0.obs;
  
  final RxList<ChatUserModel> selectedMembers = <ChatUserModel>[].obs;
  final RxString groupImagePath = "".obs;
  final RxBool isCreatingGroup = false.obs;

  void toggleMemberSelection(ChatUserModel user) {
    if (selectedMembers.any((m) => m.id == user.id)) {
      selectedMembers.removeWhere((m) => m.id == user.id);
    } else {
      selectedMembers.add(user);
    }
  }

  void clearGroupFields() {
    groupNameController.clear();
    groupDescriptionController.clear();
    groupNameLength.value = 0;
    groupDescriptionLength.value = 0;
    selectedMembers.clear();
    groupImagePath.value = "";
  }

  Future<void> createGroup() async {
    if (groupFormKey.currentState == null || !groupFormKey.currentState!.validate()) {
      return;
    }
    if (selectedMembers.isEmpty) {
      SnackbarHelper.showError(message: "Please select at least one member");
      return;
    }
    isCreatingGroup.value = true;
    try {
      final res = await _chatService.createGroup(
        name: groupNameController.text.trim(),
        description: groupDescriptionController.text.trim(),
        memberIds: selectedMembers.map((m) => m.id).toList(),
      );
      res.fold(
        (error) {
          SnackbarHelper.showError(message: error.message ?? "Failed to create group");
        },
        (success) {
          SnackbarHelper.showSuccess(message: "Group created successfully");
          clearGroupFields();
          Get.back(); // Go back from create group screen
          getChatsUser(); // Refresh chat list
        },
      );
    } catch (e) {
      SnackbarHelper.showError(message: e.toString());
    } finally {
      isCreatingGroup.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _socketService.init();
  }

  int currentUserId = 1;
  Future<void> getCurrentUserId() async {
    final userId = await StorageService().getUserId();
    currentUserId = int.parse(userId.toString());
  }

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMoreUser = false.obs;
  final RxBool hasMoreUser = true.obs;

  int totalPages = 1;
  int currentPage = 1;

  Future<void> getAllUsers({bool fetchMore = false}) async {
    if (fetchMore) {
      if (!hasMoreUser.value || isLoadingMoreUser.value) {
        return;
      }

      isLoadingMoreUser.value = true;
      currentPage++;
    } else {
      currentPage = 1;
      allUsers.clear();
      isLoading.value = true;
    }
    try {
      final res = await _chatService.getAllUsers(page: currentPage);

      res.fold(
        (error) {
          SnackbarHelper.showError(message: error.message.toString());
        },
        (success) {
          final newUsers = success.data?.allUsers ?? [];

          if (fetchMore) {
            allUsers.addAll(newUsers);
          } else {
            allUsers.assignAll(newUsers);
          }
          totalPages = success.data?.totalPages ?? 1;
          hasMoreUser.value = currentPage < totalPages;
        },
      );
    } catch (e) {
      SnackbarHelper.showError(message: e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMoreUser.value = false;
    }
  }

  Future<void> createDirectChatChannel(int userId) async {
    try {
      final res = await _chatService.createDirectChatChannel(userId: userId);
      res.fold(
        (error) {
          debugPrint("$error");
        },
        (success) {
          debugPrint("$success");
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final RxList<ChatModel> userChats = RxList<ChatModel>();
  final RxBool isLoadingUserChats = false.obs;
  final RxBool isLoadingMoreUserChats = false.obs;
  final RxBool hasMoreUserChats = true.obs;
  int totalChatsPages = 1;
  int currentChatPage = 1;

  Future<void> getChatsUser({bool isFetchMore = false}) async {
    if (isFetchMore) {
      if (!hasMoreUserChats.value || isLoadingMoreUserChats.value) {
        return;
      }
      isLoadingMoreUserChats.value = true;
      currentChatPage++;
    } else {
      currentChatPage = 1;
      userChats.clear();
      isLoadingUserChats.value = true;
    }
    try {
      final res = await _chatService.getChatsUser();
      res.fold(
        (error) => {debugPrint("$error")},
        (success) => {
          userChats.assignAll(success.data?.chats ?? []),
          totalChatsPages = success.data!.totalPages,
          hasMoreUserChats.value = currentChatPage < totalChatsPages,
        },
      );
    } catch (e) {
      return SnackbarHelper.showError(message: "$e");
    } finally {
      isLoadingUserChats.value = false;
      isLoadingMoreUserChats.value = false;
    }
  }

  final RxList<ChatMessageModel> chatMessages = RxList<ChatMessageModel>();
  final RxBool isLoadingChatMessage = false.obs;
  final RxBool isLoadingMoreChatMessage = false.obs;
  final RxBool hasMoreChatMessage = true.obs;
  // int totalChatMessage = 1;
  int currentMessagePage = 1;

  Future<void> getChatMessages({
    required int chatId,
    bool isFetchMore = false,
  }) async {
    if (isFetchMore) {
      if (!hasMoreChatMessage.value || isLoadingMoreChatMessage.value) {
        return;
      }
      isLoadingMoreChatMessage.value = true;
      currentMessagePage++;
    } else {
      currentMessagePage = 1;
      chatMessages.clear();
      isLoadingChatMessage.value = true;
    }
    try {
      final res = await _chatService.getChatMessages(chatId);
      res.fold(
        (error) => {debugPrint("$error")},
        (success) => {
          chatMessages.assignAll(success.data?.chats ?? []),
          if (success.data?.chats == null || success.data!.chats.isEmpty)
            {hasMoreChatMessage.value = false},
        },
      );
    } catch (e) {
      return SnackbarHelper.showError(message: "$e");
    } finally {
      isLoadingChatMessage.value = false;
      isLoadingMoreChatMessage.value = false;
    }
  }
}
