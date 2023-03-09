// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignin extends AuthEvent {}

class AuthCheckUserStatus extends AuthEvent {}

class AuthSignout extends AuthEvent {
  UserModel? userModel;
  AuthSignout({
    this.userModel,
  });
}
