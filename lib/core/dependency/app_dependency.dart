import 'package:flutter_chat/services/api/api_service.dart';
import 'package:flutter_chat/src/controllers/auth/auth_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppDependency {
  static Future<void> init() async {
    await dotenv.load();
    final dioService = setUpDioService();
    Get.put(AuthController(dioService: dioService));
  }

  static ApiBaseClientService setUpDioService() {
    return ApiBaseClientService();
  }

  static Future<void> deleteControllers() async {
    Get.deleteAll();
  }
}
