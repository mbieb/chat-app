import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isMe;
  final Timestamp createdAt;
  const MessageBubble({
    required this.message,
    required this.username,
    required this.isMe,
    required this.createdAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatHour = DateFormat('HH:mm').format(createdAt.toDate());
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xfffbf3d2) : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isMe
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: EdgeInsets.fromLTRB(
                  isMe ? 24 : 12,
                  2,
                  isMe ? 12 : 24,
                  2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300],
                          ),
                        ),
                      ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            isMe ? 24 : 12,
            2,
            isMe ? 12 : 24,
            4,
          ),
          child: Text(
            chatHour,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
