import 'package:flutter/material.dart';
import 'package:mooz/app/utils/dimentions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  triggerSplashScreen({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 1)).then(
      (value) => Navigator.pushReplacementNamed(
        context,
        "/login",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    triggerSplashScreen(context: context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: const Text(
          "Mooz",
        ),
      ),
    );
  }
}
