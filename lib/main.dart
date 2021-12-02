import 'package:flutter/material.dart';
import 'package:snapmap/screens/profile_creation_screen.dart';
import 'package:snapmap/services/camera_service.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snapmap/widgets/organisms/nav_controller.dart';
import 'widgets/themes/dark_green.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CameraService.getInstance().loadCameras();
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
        primarySwatch: MaterialColor(0xFF0EA47A, darkGreen),
      ),
      routes: {
        AuthScreen.routeId: (_) => const AuthScreen(),
        NavController.routeId: (_) => const NavController(),
        ProfileCreationScreen.routeId: (_) => ProfileCreationScreen(
              signUp: false,
            ),
        ProfileCreationScreen.routeId1: (_) => ProfileCreationScreen(
              signUp: true,
            ),
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
