import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final String groupChatId;
  final String peerUserId;
  const Messages({
    required this.groupChatId,
    required this.peerUserId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
            'chats',
          )
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshotData) {
        if (snapshotData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshotData.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: ((context, index) => MessageBubble(
                message: documents[index]['text'],
                isMe: documents[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                username: documents[index]['username'],
                createdAt: documents[index]['createdAt'],
                key: ValueKey(documents[index].id),
              )),
        );
      },
    );
  }
}
