import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/screens/chat_screen.dart';
import 'package:firebase_chat_app/screens/profile_page.dart';
import 'package:firebase_chat_app/widgets/profile_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Yuk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton<String>(
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: 'profile',
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Profile'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (val) {
              if (val == 'logout') {
                FirebaseAuth.instance.signOut();
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ));
              }
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                if (documents[index].id ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return Container();
                }
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          peerUsername: documents[index]['username'],
                          peerImageUrl: documents[index]['image_url'],
                          peerTokenId: documents[index]['tokenId'],
                          peerUserId: documents[index].id,
                        ),
                      ),
                    );
                  },
                  child: ProfileList(
                    username: documents[index]['username'],
                    imageUrl: documents[index]['image_url'],
                  ),
                );
              },
              itemCount: documents.length,
            );
          }
        },
      ),
    );
  }
}
