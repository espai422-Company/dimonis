import 'package:app_dimonis/screens/login-register/login_screen.dart';
import 'package:app_dimonis/screens/login-register/sing_up_screen.dart';
import 'package:flutter/material.dart';

class MainViewScreen extends StatelessWidget {
  final int initialPageIndex;
  final PageController controller;

  MainViewScreen({Key? key, required this.initialPageIndex})
      : controller = PageController(initialPage: initialPageIndex),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return LoginScreen(
              controller: controller,
            );
          } else if (index == 1) {
            return SingUpScreen(
              controller: controller,
            );
          } else {
            return null;
          }
        },
      ),
    );
  }
}
