import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(XFile pickedImage) imagePickFn;
  final String? imagePath;
  const UserImagePicker({
    required this.imagePickFn,
    this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    var pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imagePath != null) ...[
          CircleAvatar(
            backgroundColor: const Color(0xffffde6a),
            radius: 40,
            backgroundImage: widget.imagePath != null
                ? NetworkImage(widget.imagePath!)
                : null,
          ),
        ] else ...[
          CircleAvatar(
            backgroundColor: const Color(0xffffde6a),
            radius: 40,
            backgroundImage: _pickedImage != null
                ? FileImage(
                    File(_pickedImage!.path),
                  )
                : null,
          ),
        ],
        const SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: _pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image,
                color: Color(0xffffde6a),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                widget.imagePath == null ? 'Add Image' : 'Change Image',
                style: const TextStyle(
                  color: Color(0xffffde6a),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
