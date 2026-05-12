import 'package:flutter/material.dart';
import 'package:flutter_chat/core/dependency/app_dependency.dart';
import 'package:flutter_chat/core/utils/storage_service.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';

class AppInitializer {
  static Future<String> initializer() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppDependency.init();
    final token = await StorageService().getToken();
    final initialRoute = (token == null || token.isEmpty)
        ? RoutePaths.loginScreen
        : RoutePaths.bottomNav;
    return initialRoute;
  }
}
