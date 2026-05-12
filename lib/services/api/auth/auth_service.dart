import 'package:dartz/dartz.dart';
import 'package:flutter_chat/core/constant/api_end_point.dart';
import 'package:flutter_chat/core/exceptions/api_exceptions.dart';
import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/src/models/auth/login_response_model.dart';
import 'package:flutter_chat/src/models/auth/signup_response_model.dart';
import 'package:flutter_chat/src/models/base_response_model.dart';

class AuthService {
  late ApiBaseClientService _apiClient;
  AuthService({required ApiBaseClientService dioService})
    : _apiClient = dioService;

  Future<Either<ApiExceptions, BaseResponseModel<LoginResponseModel>>>
  loginUser({required String email, required String password}) async {
    try {
      final response = await _apiClient.request(
        endpoint: ApiEndPoint.login,
        method: RequestType.POST.name,
        data: {"email": email, "password": password},
      );
      if (response.data["status"] == 200 || response.data["success"] == true) {
        final data = BaseResponseModel<LoginResponseModel>.fromJson(
          response.data,
          (json) => LoginResponseModel.fromJson(json),
        );
        return Right(data);
      } else {
        return Left(ApiExceptions(message: response.data["message"]));
      }
    } on ApiExceptions catch (e) {
      return Left(ApiExceptions(message: e.message ?? e.data["message"]));
    } catch (e) {
      return Left(ApiExceptions(message: "An unexpected error occurred: $e'"));
    }
  }

  Future<Either<ApiExceptions, BaseResponseModel<SignupResponseModel>>>
  signupUser({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final response = await _apiClient.request(
        endpoint: ApiEndPoint.signup,
        method: RequestType.POST.name,
        data: {"email": email, "password": password, "fullName": fullName},
      );
      if (response.data["status"] == 200 || response.data["success"] == true) {
        final data = BaseResponseModel<SignupResponseModel>.fromJson(
          response.data,
          (json) => SignupResponseModel.fromJson(json),
        );
        return Right(data);
      } else {
        return Left(ApiExceptions(message: response.data["message"]));
      }
    } on ApiExceptions catch (e) {
      return Left(ApiExceptions(message: e.message ?? e.data["message"]));
    } catch (e) {
      return Left(ApiExceptions(message: "An unexpected error occurred: $e'"));
    }
  }
}
