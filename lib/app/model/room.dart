import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoomModel {
  String roomName;
  String ownerUid;
  List<String> activeUsers;
  String roomUid;
  RoomModel({
    required this.roomName,
    required this.ownerUid,
    required this.activeUsers,
    required this.roomUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomName': roomName,
      'ownerUid': ownerUid,
      'activeUsers': activeUsers,
      'roomUid': roomUid,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomName: map['roomName'] as String,
      ownerUid: map['ownerUid'] as String,
      activeUsers: List<String>.from(
        (map['activeUsers'] as List<dynamic>),
      ),
      roomUid: map['roomUid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
