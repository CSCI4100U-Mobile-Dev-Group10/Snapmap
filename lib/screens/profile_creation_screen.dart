// this screen handles the extra info needed after sign up (the profile picture and display name)
// this screen is pushed directly after sign up

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapmap/globals.dart';
import 'package:snapmap/utils/logger.dart';
import 'package:snapmap/widgets/molecules/avatar_picker.dart';

class ProfileCreationScreen extends StatefulWidget {
  static const String routeId = '/profile_creation';
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  late XFile selectedImage = XFile('');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final users = FirebaseFirestore.instance.collection("Users");
  String displayName = '';
  bool flag = false;

  void avatarPickerCallback(XFile image) {
    setState(() {
      selectedImage = image;
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
            AvatarPicker(user, callback: avatarPickerCallback),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Display Name Field
                  TextFormField(
                    decoration: const InputDecoration(
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
                        return 'Display name already in use';
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

            /// Save Button
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  user.displayName = displayName;
                  user.profileURL = selectedImage.path;
                  await users
                      .doc(user.username)
                      .set(user.toJson())
                      .then((value) async {
                    logger.i('Added Display Name');
                  }).catchError((e) {
                    logger.e(e);
                  });
                  Navigator.pushNamed(context, '/controller');
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
