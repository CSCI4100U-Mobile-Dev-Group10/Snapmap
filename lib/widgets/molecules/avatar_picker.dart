import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/auth_service.dart';
import 'package:snapmap/utils/logger.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker(this.user, {this.callback, Key? key}) : super(key: key);
  final User user;
  final void Function(XFile)? callback;
  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  late XFile selectedImage = XFile('');
  late User user;
  bool pickedImage = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      pickedImage = widget.user.profileURL.isNotEmpty;
      user = widget.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await imgFromGallery();
        await users
            .doc(widget.user.username)
            .set(user.toJson())
            .then((value) async {
          logger.i('Changed Profile Pic');
        }).catchError((e) {
          logger.e(e);
        });
        setState(() {
          widget.user.profileURL = selectedImage.path;
        });
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.blue,
        child: Avatar(
          pickedImage ? widget.user.profileURL : selectedImage.path,
        ),
      ),
    );
  }

  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      if (widget.callback != null) {
        widget.callback!(image);
      }
    }
  }
}
