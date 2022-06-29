import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future addTodo(String name, String description, int importance, String fromUser,
    String toUser, int duration, int deadline) async {
  final dbRef = FirebaseFirestore.instance.collection('todos').doc(toUser);
  final Map<String, dynamic> _map =
      await dbRef.get().then((value) => value.data()) ?? {'data': null};
  final _data = _map['data'] ?? [];
  _data.add({
    'id': _data.length,
    'name': name,
    'importance': importance,
    'description': description,
    'duration': duration,
    'deadline': deadline,
    'fromUser': fromUser,
    'toUser': toUser,
    'complete': false,
  });
  await dbRef.set({'data': _data});
}
