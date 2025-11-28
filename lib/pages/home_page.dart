import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/database/db.dart';
import 'package:messenger_app/models/chat_model.dart';
import 'package:messenger_app/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Чаты',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        titleSpacing: 28,
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: FirestoreDB.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки чатов',
                style: TextStyle(color: Colors.red, fontSize: 24.0),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Нет чатов',
                style: TextStyle(color: Colors.grey, fontSize: 24.0),
              ),
            );
          }

          final chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, i) {
              final chat = chats[i];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(chat: chat),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 28,
                        child: Text(
                          chat.name.isNotEmpty ? chat.name[0] : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  _formatTime(chat.time),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            chat.lastMsg.isNotEmpty
                                ? Text(
                                    'Вы: ${chat.lastMsg}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} минуты назад';
    if (diff.inHours < 24 && time.day == now.day)
      return DateFormat('HH:mm').format(time);
    if (diff.inDays < 2) return 'Вчера';
    if (diff.inDays < 7) return DateFormat('EEE', 'ru').format(time);
    return DateFormat('dd.MM.yy').format(time);
  }
}
