import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mooz/app/model/room.dart';
import 'package:mooz/app/model/user.dart';
import 'package:mooz/app/services/firebase.dart';

part 'agora_event.dart';
part 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  AgoraBloc() : super(AgoraIdle()) {
    onAgoraCreateRoomEvent();
    onAgoraJoinRoomEvent();
    onAgoraCloseRoomEvent();
  }

  void onAgoraCreateRoomEvent() => on<AgoraCreateRoomEvent>((event, emit) async {
        emit(AgoraCreatingRoom());
        await Future.delayed(const Duration(seconds: 1));
        RoomModel? roomModel = await FirebaseServices().createRoom(
          userModel: event.userModel!,
        );
        emit(AgoraJoiningRoom());
        await Future.delayed(const Duration(seconds: 1));
        if (roomModel != null) {
          emit(
            AgoraSuccess(
              roomModel: roomModel,
            ),
          );
        } else {
          emit(
            AgoraError(
              errorMessage: "An error occurred, while creating the room!",
            ),
          );
        }
      });

  void onAgoraJoinRoomEvent() => on<AgoraJoinRoomEvent>((event, emit) async {
        emit(AgoraJoiningRoom());
        await Future.delayed(const Duration(seconds: 1));
        RoomModel? roomModel = await FirebaseServices().joinRoom(
          userModel: event.userModel!,
          roomModel: event.roomModel!,
        );
        if (roomModel != null) {
          emit(
            AgoraSuccess(
              roomModel: roomModel,
            ),
          );
        } else {
          emit(
            AgoraError(
              errorMessage: "An error occurred, while joining the room!",
            ),
          );
        }
      });

  void onAgoraCloseRoomEvent() => on<AgoraCloseRoomEvent>((event, emit) async {
        emit(AgoraLeavingRoom());
        await Future.delayed(const Duration(seconds: 1));
        bool roomClosed = await FirebaseServices().closeRoom(
          userModel: event.userModel!,
          roomModel: event.roomModel!,
        );
        if (roomClosed) {
          log("Room closed");
          emit(
            AgoraRoomClosed(),
          );
        } else {
          emit(
            AgoraError(
              errorMessage: "An error occurred, while closing the room!",
            ),
          );
        }
      });
}
