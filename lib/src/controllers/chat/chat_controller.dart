import 'package:flutter/material.dart';
import 'package:flutter_chat/core/utils/snackbar_helper.dart';
import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/services/api/chat/chat_service.dart';
import 'package:flutter_chat/src/models/chat/all_users_response_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late ChatService _chatService;
  ChatController({required ApiBaseClientService dioService})
    : _chatService = ChatService(dioService: dioService);

  final RxList<ChatUserModel> allUsers = RxList<ChatUserModel>();

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

























}
