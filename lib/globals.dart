// global variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/models/user.dart';

final users = FirebaseFirestore.instance.collection("Users");

User user = User(
  '', '', '', '', ''
);
