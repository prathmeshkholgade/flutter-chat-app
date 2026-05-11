import 'package:flutter/material.dart';
import 'package:flutter_chat/core/dependency/app_dependency.dart';
import 'package:flutter_chat/core/theme/theme.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/services/routes/routes.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() {
  AppDependency.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          getPages: AppRoutes.routes,
          initialRoute: RoutePaths.loginScreen,
          title: 'Chat',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
