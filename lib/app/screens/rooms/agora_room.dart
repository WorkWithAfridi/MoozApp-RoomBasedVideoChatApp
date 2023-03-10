import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/model/room.dart';
import 'package:mooz/app/utils/dimentions.dart';

import '../../bloc/agora/agora_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../shared/widgets/snackbar.dart';

class AgoraRoom extends StatefulWidget {
  AgoraRoom({
    super.key,
    required this.roomModel,
  });

  late RoomModel roomModel;

  @override
  State<AgoraRoom> createState() => _AgoraRoomState();
}

class _AgoraRoomState extends State<AgoraRoom> {
  late AuthBloc authBloc;

  late AgoraBloc agoraBloc;

  @override
  void dispose() {
    if (agoraBloc.state is AgoraSuccess) {
      agoraBloc.add(
        AgoraCloseRoomEvent(
          userModel: authBloc.state.user,
          roomModel: widget.roomModel,
        ),
      );
    }
    super.dispose();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    authBloc = context.read<AuthBloc>();
    agoraBloc = context.read<AgoraBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            agoraBloc.add(
              AgoraCloseRoomEvent(
                userModel: authBloc.state.user,
                roomModel: widget.roomModel,
              ),
            );
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        title: Text(
          widget.roomModel.roomName,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: BlocListener<AgoraBloc, AgoraState>(
        listener: (agoraContext, state) {
          if (state is AgoraRoomClosed) {
            Navigator.of(context).pop();
          } else if (state is AgoraError) {
            log("Agora failed");
            showSnackbar(
              context: context,
              message: state.errorMessage,
            );
          }
        },
        child: SizedBox(
          height: getHeight(
            context: context,
          ),
          width: getWidth(
            context: context,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Builder(
                builder: (context) {
                  final agoraState = context.watch<AgoraBloc>().state;
                  if (agoraState is AgoraLeavingRoom) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Leaving room...",
                        )
                      ],
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
