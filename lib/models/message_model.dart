import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final DateTime time;
  final bool isMine;
  final int status;

  MessageModel(this.id, this.text, this.time, this.isMine, this.status);

  factory MessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MessageModel(
      id,
      data['text'] ?? '',
      (data['time'] as Timestamp).toDate(),
      data['isMine'] ?? false,
      data['status'] ?? 0,
    );
  }
}