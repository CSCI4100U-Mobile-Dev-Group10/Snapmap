import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:snapmap/models/user.dart';
import 'user_service.dart';

class FriendRequests {
  late FlutterLocalNotificationsPlugin notification;

  FriendRequests() {
    initNotification();
  }

  //initialize notification
  initNotification() {
    notification = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iOSInitializationSettings =
        const IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    notification.initialize(initializationSettings);
  }

  Future<String?> selectNotification(String? payload) async {}

  Future showNotification() async {
    User user = UserService.getInstance().getCurrentUser()!;
    var numbRequests = user.receivedFriendRequests.length;
    if (numbRequests != 0) {
      String message = '';
      if (numbRequests > 1) {
        message = "You have " + numbRequests.toString() + " friend requests.";
      } else {
        message = "You have " + numbRequests.toString() + " friend request.";
      }

      var android = const AndroidNotificationDetails("channelId", "channelName",
          priority: Priority.high, importance: Importance.max);
      var platformDetails = NotificationDetails(android: android);
      await notification.show(100, "Snapmap", message, platformDetails);
    }
  }
}
