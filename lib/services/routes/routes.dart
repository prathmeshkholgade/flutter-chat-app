import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/src/views/screens/auth/login_screen.dart';
import 'package:flutter_chat/src/views/screens/auth/signup_screen.dart';
import 'package:flutter_chat/src/views/screens/bottom_nav.dart';
import 'package:flutter_chat/src/views/screens/chat/all_users_screen.dart';
import 'package:flutter_chat/src/views/screens/chat/chat_detail_screen.dart';
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
    GetPage(
      name: RoutePaths.bottomNav,
      page: () => BottomNav(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutePaths.allUsersScreen,
      page: () => AllUsersScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutePaths.chatDetailScreen,
      page: () => ChatDetailScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
