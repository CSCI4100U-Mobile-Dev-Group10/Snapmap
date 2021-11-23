// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// this screen handles the extra info needed after sign up (the profile picture and display name)
// this screen is pushed directly after sign up

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:snapmap/globals.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  late XFile selectedImage = XFile('');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final users = FirebaseFirestore.instance.collection("Users");
  String displayName = '';
  bool flag = false;

  // get image from image gallery
  imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (image != null) {
        selectedImage = image;
      }
    });
  }
  // check if display name is already in use for validator
  checkUserDN(String dn) async {
    var result =
        await users.where('display_name', isEqualTo: dn.toString()).get();
    if (result.docs.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                imgFromGallery();
                setState(() {});
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue,
                child: selectedImage.path != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(selectedImage.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) async {
                      checkUserDN(text).then((value1) {
                        if (value1) {
                          flag = true;
                        } else {
                          flag = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Must enter display name';
                      } else if (flag) {
                        return 'Display Name already in use';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      displayName = value.toString();
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  user.displayName = displayName;
                  user.profileURL = selectedImage.path;
                  await users.doc(user.username).set({
                    'email': user.email,
                    'password': user.password,
                    'display_name': displayName,
                    'profileURL': selectedImage.path,
                  }).then((value) async {
                    print('Added Display Name');
                  }).catchError((error) => print(''));
                  Navigator.pushNamed(context, '/controller');
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}