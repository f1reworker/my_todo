import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_refresh/backend/utils.dart';

void updateTodoForDay() async {
  final Map<String, dynamic>? _allTodosMap = await FirebaseFirestore.instance
      .collection('todos')
      .doc(Utils.userId)
      .get()
      .then((value) => value.data());
  if (_allTodosMap == null) return;
  final List<Map<String, dynamic>> _allTodos = [];
  for (var element in _allTodosMap.keys) {
    if (element != 'todosForDay') {
      final Map<String, dynamic> _data = _allTodosMap[element];
      _data['rating'] = (_data['deadline'] -
              DateTime.now().millisecondsSinceEpoch / 1000 -
              _data['duration'] * 60) *
          (5 - _data['importance']);
      _allTodos.add(_data);
    }
  }
  _allTodos.sort((a, b) => a['rating'].compareTo(b['rating']));
  int _time = 0;
  final List<String> _todosForDay = [];
  for (var element in _allTodos) {
    if (!element['complete'] && element['rating'] < 0) {
      _todosForDay.add(element['id'].toString());
      _time += element['duration'] as int;
    } else if (!element['complete'] &&
        Utils.workday - _time - element['duration'] > 0) {
      _todosForDay.add(element['id'].toString());
      _time += element['duration'] as int;
    }
  }
  await FirebaseFirestore.instance
      .collection('todos')
      .doc(Utils.userId)
      .update({'todosForDay': _todosForDay});
}

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
