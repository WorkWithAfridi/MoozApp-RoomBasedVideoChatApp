import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/utils/dimentions.dart';

class Homeframe extends StatelessWidget {
  const Homeframe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Text(
              "Homeframe - ${state.user!.userName}",
            );
          },
        ),
      ),
      body: SizedBox(
        height: getHeight(
          context: context,
        ),
        width: getWidth(
          context: context,
        ),
      ),
    );
  }
}
