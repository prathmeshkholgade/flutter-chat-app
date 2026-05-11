import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/src/views/screens/auth/login_screen.dart';
import 'package:flutter_chat/src/views/screens/auth/signup_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RoutePaths.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutePaths.signupScreen,
      page: () => SignupScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
