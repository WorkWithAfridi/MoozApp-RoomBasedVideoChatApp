// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  AuthState({
    this.user,
  });
  UserModel? user;

  @override
  List<Object> get props => [];
}

class AuthIdle extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  Authenticated({required super.user});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  String errorMessage;
  AuthError({
    required this.errorMessage,
  });
}
