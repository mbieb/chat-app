import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NewMessages extends StatefulWidget {
  final String peerTokenId;
  final String groupChatId;
  const NewMessages({
    required this.peerTokenId,
    required this.groupChatId,
    Key? key,
  }) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final TextEditingController _controller = TextEditingController();
  String _enteredMessage = '';

  void sendMessage() async {
    if (_enteredMessage.trim().isEmpty) return;
    var message = _enteredMessage;
    _controller.clear();
    _enteredMessage = '';
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.groupChatId)
        .collection(widget.groupChatId)
        .add(
      {
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData['username'],
      },
    );

    sendNotification(
      [
        widget.peerTokenId,
      ],
      message,
      userData['username'],
    );
  }

  Future sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            "19eee5ca-6511-4964-9eac-7e66a7d55784", //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon": "",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Send Message..',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              onSubmitted: (val) => sendMessage(),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
