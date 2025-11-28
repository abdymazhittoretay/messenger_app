import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String name;
  final String lastMsg;
  final DateTime time;
  final bool online;

  ChatModel(this.id, this.name, this.lastMsg, this.time, this.online);

  factory ChatModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ChatModel(
      id,
      data['name'] ?? '',
      data['lastMsg'] ?? '',
      (data['timestamp'] as Timestamp).toDate(),
      data['online'] ?? false,
    );
  }
}