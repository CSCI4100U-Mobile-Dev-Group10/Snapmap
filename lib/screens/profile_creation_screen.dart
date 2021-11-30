// this screen handles the extra info needed after sign up (the profile picture and display name)
// this screen is pushed directly after sign up

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/logger.dart';
import 'package:snapmap/widgets/molecules/avatar_picker.dart';
import 'package:snapmap/widgets/organisms/nav_controller.dart';

class ProfileCreationScreen extends StatefulWidget {
  static const String routeId = '/profile_creation';
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  late String imageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final users = FirebaseFirestore.instance.collection("Users");
  User user = UserService.getInstance().getUser()!;
  String displayName = '';
  bool flag = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      imageUrl = user.profileUrl;
    });
  }

  void avatarPickerCallback(String selectedImage) {
    setState(() {
      imageUrl = selectedImage;
    });
  }

  // check if display name is already in use for validator
  checkUserDN(String dn) async {
    var result =
        await users.where('displayName', isEqualTo: dn.toString()).get();
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

            /// This form sets the display name field
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: user.displayName,
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
                  user.profileUrl = imageUrl;
                  await users
                      .doc(user.username)
                      .set(user.toMap())
                      .then((value) async {
                    logger.i('Added Display Name');
                  }).catchError((e) {
                    logger.e(e);
                  });
                  Navigator.pushNamed(context, NavController.routeId);
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
