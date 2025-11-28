import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String name;
  final String lastMsg;
  final DateTime time;

  ChatModel(this.id, this.name, this.lastMsg, this.time);

  factory ChatModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ChatModel(
      id,
      data['name'] ?? '',
      data['lastMsg'] ?? '',
      (data['time'] as Timestamp).toDate()
    );
  }
}