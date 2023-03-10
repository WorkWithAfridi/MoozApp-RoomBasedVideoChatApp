import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mooz/app/model/room.dart';
import 'package:mooz/app/model/user.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<RoomModel?> createRoom({required UserModel userModel}) async {
    try {
      RoomModel roomModel = RoomModel(
        roomName: "${userModel.userName}'s room",
        ownerUid: userModel.uid,
        activeUsers: [
          userModel.uid,
        ],
        roomUid: const Uuid().v4(),
      );
      await firebaseFirestore.collection('rooms').doc(roomModel.roomUid).set(roomModel.toMap());
      return roomModel;
    } on FirebaseException {
      return null;
    }
  }

  Future<RoomModel?> joinRoom({
    required UserModel userModel,
    required RoomModel roomModel,
  }) async {
    try {
      roomModel.activeUsers.add(userModel.uid);
      await firebaseFirestore.collection('rooms').doc(roomModel.roomUid).update(roomModel.toMap());
      return roomModel;
    } on FirebaseException {
      return null;
    }
  }

  Future<bool> closeRoom({
    required UserModel userModel,
    required RoomModel roomModel,
  }) async {
    try {
      bool isOwner = userModel.uid == roomModel.ownerUid;
      if (isOwner) {}
      roomModel.activeUsers.removeWhere(
        (element) => element == userModel.uid,
      );
      await firebaseFirestore.collection('rooms').doc(roomModel.roomUid).update(roomModel.toMap());
      return true;
    } on FirebaseException {
      return false;
    }
  }
}
