import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooz/app/bloc/agora/agora_bloc.dart';
import 'package:mooz/app/bloc/auth/auth_bloc.dart';
import 'package:mooz/app/model/room.dart';
import 'package:mooz/app/screens/login/login.dart';
import 'package:mooz/app/screens/rooms/agora_room.dart';
import 'package:mooz/app/services/firebase.dart';
import 'package:mooz/app/shared/widgets/snackbar.dart';
import 'package:mooz/app/utils/dimentions.dart';

class Homeframe extends StatelessWidget {
  Homeframe({super.key});

  late AuthBloc authBloc;
  late AgoraBloc agoraBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = context.read<AuthBloc>();
    agoraBloc = context.read<AgoraBloc>();
    return Scaffold(
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
                  authBloc.add(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authBloc.state is Authenticated) {
            agoraBloc.add(
              AgoraCreateRoomEvent(
                userModel: authBloc.state.user,
              ),
            );
          }
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
          BlocListener<AgoraBloc, AgoraState>(
            listener: (agoraContext, state) {
              if (state is AgoraSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgoraRoom(
                      roomModel: state.roomModel!,
                    ),
                  ),
                );
              } else if (state is AgoraError) {
                showSnackbar(
                  context: context,
                  message: state.errorMessage,
                );
              }
            },
          ),
        ],
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
              SizedBox(
                height: getHeight(
                  context: context,
                ),
                width: getWidth(
                  context: context,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      StreamBuilder(
                        stream: FirebaseServices().firebaseFirestore.collection('rooms').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  RoomModel roomModel = RoomModel.fromMap(
                                    snapshot.data!.docs[index].data(),
                                  );
                                  return RoomCard(roomModel: roomModel);
                                },
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  final authState = context.watch<AuthBloc>().state;
                  final agoraState = context.watch<AgoraBloc>().state;
                  if (authState is AuthLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else if (agoraState is AgoraCreatingRoom || agoraState is AgoraJoiningRoom) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        agoraState is AgoraCreatingRoom || agoraState is AgoraJoiningRoom
                            ? Text(
                                agoraState is AgoraCreatingRoom
                                    ? "Creating room..."
                                    : agoraState is AgoraJoiningRoom
                                        ? "Joining room..."
                                        : "",
                              )
                            : const SizedBox.shrink(),
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

class RoomCard extends StatelessWidget {
  RoomCard({
    super.key,
    required this.roomModel,
  });

  final RoomModel roomModel;
  late AuthBloc authBloc;
  late AgoraBloc agoraBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = context.read<AuthBloc>();
    agoraBloc = context.read<AgoraBloc>();
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: GestureDetector(
        onTap: () {
          agoraBloc.add(AgoraJoinRoomEvent(
            userModel: authBloc.state.user,
            roomModel: roomModel,
          ));
        },
        child: SizedBox(
          height: kToolbarHeight + 20,
          width: getWidth(context: context),
          child: Card(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(
                16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    roomModel.roomName,
                  ),
                  Row(
                    children: [
                      Text(
                        " + ${roomModel.activeUsers.length}",
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.group,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
