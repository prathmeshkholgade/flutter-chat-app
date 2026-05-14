import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/core/constant/api_end_point.dart';
import 'package:flutter_chat/core/exceptions/api_exceptions.dart';
import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/src/models/base_response_model.dart';
import 'package:flutter_chat/src/models/chat/all_users_response_model.dart';

class ChatService {
  late ApiBaseClientService _apiClient;
  ChatService({required ApiBaseClientService dioService})
    : _apiClient = dioService;

  Future<Either<ApiExceptions, BaseResponseModel<AllUsersResponseModel>>>
  getAllUsers({int page = 1}) async {
    try {
      final res = await _apiClient.request(
        endpoint: ApiEndPoint.getAllUser,
        method: RequestType.GET.name,
        queryParams: {"page": page},
      );

      if (res.data["status"] == 200) {
        final data = BaseResponseModel<AllUsersResponseModel>.fromJson(
          res.data,
          (json) => AllUsersResponseModel.fromJson(json),
        );
        return Right(data);
      } else {
        return Left(
          ApiExceptions(message: res.data["message"] ?? "An error occurred"),
        );
      }
    } on ApiExceptions catch (e) {
      return Left(ApiExceptions(message: e.message ?? e.data["message"]));
    } catch (e) {
      debugPrint(e.toString());
      return Left(ApiExceptions(message: e.toString()));
    }
  }

  Future<Either<ApiExceptions, dynamic>> createDirectChatChannel({
    required int userId,
  }) async {
    try {
      final res = await _apiClient.request(
        endpoint: ApiEndPoint.directChat,
        method: RequestType.POST.name,
        data: {"userId": userId},
      );
      if (res.data["status"] == 200) {
        return Right(res.data);
      } else {
        return Left(ApiExceptions(message: "An error occurred"));
      }
    } on ApiExceptions catch (e) {
      return Left(ApiExceptions(message: e.message));
    } catch (e) {
      return Left(ApiExceptions(message: e.toString()));
    }
  }
}
