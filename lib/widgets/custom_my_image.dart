import 'dart:io';

import 'package:flutter/material.dart';

class CustomMyImage extends StatelessWidget {
  const CustomMyImage(
      {super.key,
      required this.file,
      required this.userImage,
      required this.onTap});
  final File? file;
  final String userImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 67,
          backgroundColor: Colors.deepPurpleAccent,
          child: CircleAvatar(
            radius: 65,
            backgroundImage: showImage(),
            backgroundColor: Colors.grey[200],
          ),
        ),
        Positioned(
            bottom: 0.0,
            right: 0.0,
            child: InkWell(
              onTap: onTap,
              child: CircleAvatar(
                radius: 21.5,
                backgroundColor: Colors.grey[400],
                child: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.camera_alt_outlined),
                ),
              ),
            ))
      ],
    );
  }

  ImageProvider showImage() {
    if (file != null) {
      return FileImage(File(file!.path)) as ImageProvider<Object>;
    } else if (userImage.isNotEmpty) {
      return FileImage(File(userImage)) as ImageProvider<Object>;
    } else {
      return const AssetImage('assets/images/my_image.jpg');
    }
  }
}
