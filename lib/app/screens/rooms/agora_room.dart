import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/model/room.dart';
import 'package:mooz/app/utils/dimentions.dart';

import '../../bloc/agora/agora_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../shared/widgets/snackbar.dart';
import '../../utils/agora_settings.dart';

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

  late AgoraClient agoraClient;

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

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
    agoraBloc = context.read<AgoraBloc>();
    agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: channgeId,
        tempToken: token,
      ),
    );
    agoraClient.initialize();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
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
      ),
      backgroundColor: Colors.white,
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: kToolbarHeight * 2.5,
                  child: AgoraVideoButtons(
                    client: agoraClient,
                    verticalButtonPadding: 28,
                    enabledButtons: const [
                      BuiltInButtons.callEnd,
                      BuiltInButtons.toggleMic,
                      BuiltInButtons.switchCamera,
                      // BuiltInButtons.toggleCamera,
                      // BuiltInButtons.screenSharing,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  height: getHeight(context: context) - (kToolbarHeight * 2.5),
                  width: getWidth(context: context),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: AgoraVideoViewer(
                      layoutType: Layout.oneToOne,
                      client: agoraClient,
                      showNumberOfUsers: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
