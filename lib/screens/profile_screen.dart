// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables

// profile screen

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapmap/globals.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late XFile selectedImage = XFile('');
  // final users = FirebaseFirestore.instance.collection("Users");
  bool pickedImage = false;

  imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        selectedImage = image;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (user.profileURL != '') {
      pickedImage = true;
    }
  }

  circleAvatarCheck(String path) {
    if (path != '') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          File(path),
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      );
    } else {
      Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(50)),
        width: 100,
        height: 100,
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await imgFromGallery();
                await users.doc(user.username).set({
                  'email': user.email,
                  'password': user.password,
                  'display_name': user.displayName,
                  'profileURL': selectedImage.path,
                }).then((value) async {
                  print('Changed Profile Pic');
                }).catchError((error) => print(''));
                user.profileURL = selectedImage.path;
                setState(() {});
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue,
                child: pickedImage
                    ? circleAvatarCheck(user.profileURL)
                    : circleAvatarCheck(selectedImage.path),
              ),
            ),
            Column(
              children: [
                Text(user.username),
                Text(user.displayName),
              ],
            ),
          ],
        ),
        // Qr code
        // Friends list
      ],
    );
  }
}
