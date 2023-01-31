import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication(String msg, {bool playSound = false}) async {
    await _flutterLocalNotificationsPlugin.cancel(0);
    var android = AndroidNotificationDetails("id", "channel",
        channelDescription: "description",
        styleInformation: BigTextStyleInformation(msg),
        importance: Importance.high,
    playSound: playSound,enableVibration: false);

    var ios = DarwinNotificationDetails(presentSound: playSound);

    var platform = NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(0, "BreakerPRO", msg, platform,
        payload: "Welcome to demo app");
  }

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
