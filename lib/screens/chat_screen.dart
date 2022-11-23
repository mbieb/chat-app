import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widgets/messages.dart';
import 'package:firebase_chat_app/widgets/new_messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String peerUsername;
  final String peerImageUrl;
  final String peerTokenId;
  final String peerUserId;
  const ChatScreen({
    required this.peerUsername,
    required this.peerImageUrl,
    required this.peerTokenId,
    required this.peerUserId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    String groupChatId = '';
    if (userId.hashCode <= peerUserId.hashCode) {
      groupChatId = '$userId-$peerUserId';
    } else {
      groupChatId = '$peerUserId-$userId';
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(peerImageUrl),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(peerUsername),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              groupChatId: groupChatId,
              peerUserId: peerUserId,
            ),
          ),
          NewMessages(
            peerTokenId: peerTokenId,
            groupChatId: groupChatId,
          ),
        ],
      ),
    );
  }
}
