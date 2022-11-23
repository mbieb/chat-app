import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final String username;
  final String imageUrl;
  const ProfileList({
    required this.username,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(username),
        ],
      ),
    );
  }
}
