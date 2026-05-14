import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_chat/core/enviroment/enviroment.dart';
import 'package:flutter_chat/core/exceptions/api_exceptions.dart';
import 'package:flutter_chat/core/utils/storage_service.dart';

enum RequestType { GET, POST, PUT, PATCH, DELETE }

extension HttpMethodExtension on RequestType {
  String get name {
    switch (this) {
      case RequestType.GET:
        return 'GET';
      case RequestType.POST:
        return 'POST';
      case RequestType.PUT:
        return 'PUT';
      case RequestType.PATCH:
        return 'PATCH';
      case RequestType.DELETE:
        return 'DELETE';
    }
  }
}

class ApiBaseClientService {
  late Dio _dio;

  ApiBaseClientService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Enviroment.baseUrl,
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        responseHeader: true,
        requestBody: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final token = await StorageService().getToken();
              options.headers["Authorization"] = "Bearer $token";
              return handler.next(options);
            },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> request({
    required String endpoint,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool isMultipart = false,
    FormData? formData,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: isMultipart ? formData : data,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: isMultipart ? {'Content-Type': 'multipart/form-data'} : null,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    } on SocketException {
      throw NoInternetException(message: 'No internet connection');
    } catch (e) {
      throw UnknownException(message: 'Unexpected error: $e');
    }
  }

  ApiExceptions _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiExceptions(message: 'Request cancelled');

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException('Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final data = error.response?.data;

        final message = data is Map<String, dynamic>
            ? data['message'] ?? 'An error occurred'
            : 'An error occurred';

        if (statusCode == 400) {
          return BadRequestException(message: message, data: data);
        } else if (statusCode == 401) {
          return UnauthorizedException(message: 'Unauthorized', data: data);
        } else if (statusCode == 503) {
          return NoInternetException(message: 'Service unavailable');
        }

        return ApiExceptions(
          message: message,
          statusCode: statusCode,
          data: data,
        );

      case DioExceptionType.connectionError:
        return ApiExceptions(
          message: 'Network error. Please check your connection.',
        );

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return UnknownException(message: 'Unknown error');
    }
  }
}
