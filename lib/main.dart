import 'package:flutter/material.dart';
import 'package:snapmap/screens/profile_creation_screen.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snapmap/widgets/organisms/nav_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SnapMap());
}

class SnapMap extends StatelessWidget {
  const SnapMap({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AuthScreen.routeId: (_) => const AuthScreen(),
        NavController.routeId: (_) => const NavController(),
        ProfileCreationScreen.routeId: (_) => const ProfileCreationScreen(),
        // Below are accessed through NavController
        // '/socialFeed': (_) => SocialFeedScreen(),
        // '/profileScreen': (_) => ProfileScreen(),
        // '/cameraScreen': (_) => CameraViewScreen(),
      },
      initialRoute: AuthScreen.routeId,
      builder: (BuildContext context, Widget? child) {
        return Container(
          color: Colors.white,
          child: SafeArea(child: child ?? Container()),
        );
      },
    );
  }
}
