import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/theme.dart';
import 'package:flutter_chat/core/utils/app_initializer.dart';
import 'package:flutter_chat/services/routes/routes.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() async {
  final initialRoute = await AppInitializer.initializer();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          getPages: AppRoutes.routes,
          initialRoute: initialRoute,
          title: 'Chat',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
