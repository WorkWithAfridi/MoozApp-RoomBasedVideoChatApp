// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'agora_bloc.dart';

abstract class AgoraState extends Equatable {
  const AgoraState();

  @override
  List<Object> get props => [];
}

class AgoraIdle extends AgoraState {}

class AgoraCreatingRoom extends AgoraState {
  UserModel? userModel;
  AgoraCreatingRoom({
    this.userModel,
  });
}

class AgoraJoiningRoom extends AgoraState {}

class AgoraSuccess extends AgoraState {
  RoomModel? roomModel;
  AgoraSuccess({
    this.roomModel,
  });
}

class AgoraError extends AgoraState {
  String errorMessage;
  AgoraError({
    required this.errorMessage,
  });
}

class AgoraLeavingRoom extends AgoraState {}

class AgoraClosingRoom extends AgoraState {}

class AgoraRoomClosed extends AgoraState {}
