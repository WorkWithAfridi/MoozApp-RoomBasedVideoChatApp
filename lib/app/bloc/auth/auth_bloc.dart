import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mooz/app/model/user.dart';
import 'package:mooz/app/services/authentication.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthIdle()) {
    signin();
    checkUserStatus();
  }

  void signin() {
    return on<AuthSignin>(
      (event, emit) async {
        emit(AuthLoading());
        await Future.delayed(const Duration(seconds: 1));
        UserModel? userModel = await Authentication().signInWithGoogle();
        log("User model : $userModel");
        if (userModel != null) {
          emit(
            Authenticated(
              user: userModel,
            ),
          );
        } else {
          emit(
            AuthError(
              errorMessage: "An error occurred trying to log you in!",
            ),
          );
        }
      },
    );
  }

  void checkUserStatus() {
    return on<AuthCheckUserStatus>(
      (event, emit) async {
        UserModel? userModel = await Authentication().isUserSignedIn();
        if (userModel != null) {
          emit(
            Authenticated(
              user: userModel,
            ),
          );
        } else {
          emit(
            Unauthenticated(),
          );
        }
      },
    );
  }
}
