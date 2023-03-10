// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'agora_bloc.dart';

abstract class AgoraEvent extends Equatable {
  const AgoraEvent();

  @override
  List<Object> get props => [];
}

class AgoraCreateRoomEvent extends AgoraEvent {
  UserModel? userModel;
  AgoraCreateRoomEvent({
    this.userModel,
  });
}

class AgoraJoinRoomEvent extends AgoraEvent {
  UserModel? userModel;
  RoomModel? roomModel;
  AgoraJoinRoomEvent({
    this.userModel,
    this.roomModel,
  });
}

class AgoraCloseRoomEvent extends AgoraEvent {
  UserModel? userModel;
  RoomModel? roomModel;
  AgoraCloseRoomEvent({
    this.userModel,
    this.roomModel,
  });
}
