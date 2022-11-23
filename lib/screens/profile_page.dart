import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widgets/user_image_picker.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _userImageFile;

  @override
  Widget build(BuildContext context) {
    void _pickedImage(XFile file) {
      _userImageFile = file;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Profile'),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.docs.first;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  UserImagePicker(
                    imagePickFn: _pickedImage,
                    imagePath: data['image_url'],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      data['username'],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      data['email'],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
