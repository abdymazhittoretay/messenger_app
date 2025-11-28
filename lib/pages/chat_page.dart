import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:messenger_app/database/db.dart';
import 'package:messenger_app/models/chat_model.dart';
import 'package:messenger_app/models/message_model.dart';

class ChatPage extends StatefulWidget {
  final ChatModel chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: Text(
                widget.chat.name[0],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text('В сети', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: FirestoreDB.getMessages(widget.chat.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Ошибка загрузки сообщений',
                          style: TextStyle(color: Colors.red, fontSize: 24.0),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Нет сообщений',
                          style: TextStyle(color: Colors.grey, fontSize: 24.0),
                        ),
                      );
                    }

                    final List<MessageModel> messages = snapshot.data!.reversed
                        .toList();

                    return GroupedListView<MessageModel, DateTime>(
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      elements: messages,
                      groupBy: (message) => DateTime(
                        message.time.year,
                        message.time.month,
                        message.time.day,
                      ),
                      groupHeaderBuilder: (MessageModel message) => Center(
                        child: Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${message.time.day.toString().padLeft(2, "0")} ${message.time.month.toString().padLeft(2, "0")} ${message.time.year}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, MessageModel message) {
                        return Align(
                          alignment: message.isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: message.isMine
                                ? Colors.blue
                                : Colors.grey[300],
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: message.isMine
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.attach_file, size: 32.0),
                    onPressed: () {},
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Сообщение',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.mic_none_outlined, size: 32.0),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
