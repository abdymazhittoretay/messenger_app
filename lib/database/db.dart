import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/models/chat_model.dart';
import 'package:messenger_app/models/message_model.dart';

class DB {
  static final _instance = FirebaseFirestore.instance;

  static Stream<List<ChatModel>> getChats() {
    return _instance
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  static Stream<List<MessageModel>> getMessages(String chatId) {
    return _instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  static Future<void> sendMessage(String chatId, String text) async {
    final now = DateTime.now();
    
    await _instance.collection('chats').doc(chatId).update({
      'lastMsg': text,
      'time': now,
    });

    await _instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': text,
      'time': now,
      'isMine': true,
      'status': 2,
    });
  }
}