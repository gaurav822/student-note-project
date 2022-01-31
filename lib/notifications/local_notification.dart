import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static FlutterLocalNotificationsPlugin _notifications;

  static AndroidNotificationDetails androidSettings;

  static Initializer() {
    _notifications = FlutterLocalNotificationsPlugin();
    androidSettings = AndroidNotificationDetails("111", "test channel",
        importance: Importance.high, priority: Priority.max);
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetting = InitializationSettings(android: androidInit);
    _notifications.initialize(initSetting);
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel desc', importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
      );
}
