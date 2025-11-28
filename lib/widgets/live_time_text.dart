import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveTimeText extends StatefulWidget {
  final DateTime time;
  const LiveTimeText({super.key, required this.time});

  @override
  State<LiveTimeText> createState() => _LiveTimeTextState();
}

class _LiveTimeTextState extends State<LiveTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(widget.time),
      style: TextStyle(fontSize: 14, color: Colors.grey),
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