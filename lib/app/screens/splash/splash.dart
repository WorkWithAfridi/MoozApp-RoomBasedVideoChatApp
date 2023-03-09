import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/utils/dimentions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  triggerSplashScreen({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 1)).then(
      (value) => context.read<AuthBloc>().add(
            AuthCheckUserStatus(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    triggerSplashScreen(context: context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/homeframe');
        }
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          height: getHeight(context: context),
          width: getWidth(context: context),
          child: const Text(
            "Mooz",
          ),
        ),
      ),
    );
  }
}
