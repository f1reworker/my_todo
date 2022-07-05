import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void updateTodoForDay() {}

Future showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
      0, 'GeeksforGeeks', DateTime.now().toString(), platformChannelSpecifics,
      payload: 'Default_Sound');
}

void initSettings() {
  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
  var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var ios = const IOSInitializationSettings();
  var settings = InitializationSettings(android: android, iOS: ios);
  flip.initialize(settings);
  showNotificationWithDefaultSound(flip);
}
