import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/shared/widgets/snackbar.dart';
import 'package:mooz/app/utils/dimentions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showSnackbar(
            context: context,
            message: state.errorMessage,
          );
        } else if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/homeframe');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mooz - Sign in"),
        ),
        body: SizedBox(
          height: getHeight(
            context: context,
          ),
          width: getWidth(
            context: context,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return state is AuthLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  AuthSignin(),
                                );
                          },
                          child: const Text(
                            "sign in with Google",
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
