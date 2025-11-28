import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/models/message_model.dart';

class GroupedList extends StatelessWidget {
  final List<MessageModel> messages;

  const GroupedList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<MessageModel, DateTime>(
      reverse: true,
      order: GroupedListOrder.DESC,
      elements: messages,
      groupBy: (message) =>
          DateTime(message.time.year, message.time.month, message.time.day),
      groupHeaderBuilder: (MessageModel message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _formatTime(message.time),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      itemBuilder: (context, MessageModel message) {
        return Align(
          alignment: message.isMine
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Card(
            color: message.isMine ? Colors.blue : Colors.grey[300],
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: message.isMine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '  ${DateFormat('HH:mm').format(message.time)}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: message.isMine ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  if (message.status == 1 && message.isMine)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
                      child: Icon(
                        Icons.done,
                        size: 14.0,
                        color: Colors.white70
                      ),
                    )
                  else if (message.status == 2 && message.isMine)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
                      child: Icon(
                        Icons.done_all,
                        size: 14.0,
                        color: Colors.white70
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} минуты назад';
    if (diff.inHours < 24 && time.day == now.day) {
      return DateFormat('HH:mm').format(time);
    }
    if (diff.inDays < 2) return 'Вчера';
    if (diff.inDays < 7) return DateFormat('EEE', 'ru').format(time);
    return DateFormat('dd.MM.yy').format(time);
  }
}
