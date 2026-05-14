import 'package:flutter/material.dart';
import 'package:flutter_chat/services/routes/route_paths.dart';
import 'package:flutter_chat/src/views/widgets/app_button.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Profile Screen"),
          AppButton(title: "Logout", onPressed: () {
            Get.toNamed(RoutePaths.loginScreen);
          }),
        ],
      ),
    );
  }
}
