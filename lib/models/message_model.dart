import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final DateTime time;
  final bool isMine;
  final int status;

  Message(this.id, this.text, this.time, this.isMine, this.status);

  factory Message.fromFirestore(String id, Map<String, dynamic> data) {
    return Message(
      id,
      data['text'] ?? '',
      (data['time'] as Timestamp).toDate(),
      data['isMine'] ?? false,
      data['status'] ?? 0,
    );
  }
}