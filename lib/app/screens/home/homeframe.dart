import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/utils/dimentions.dart';

class Homeframe extends StatelessWidget {
  const Homeframe({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state is Unauthenticated
                  ? const SizedBox.shrink()
                  : Text(
                      "Homeframe - ${state.user!.userName}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    );
            },
          ),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthSignout(
                            userModel: state.user,
                          ),
                        );
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                );
              },
            ),
          ],
        ),
        body: SizedBox(
          height: getHeight(
            context: context,
          ),
          width: getWidth(
            context: context,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
