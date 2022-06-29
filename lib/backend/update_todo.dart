import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future updateTodo(
  int id,
  String toUser, {
  bool? complete,
  String? name,
  String? description,
  int? importance,
  String? fromUser,
  int? duration,
  int? deadline,
}) async {
  final dbRef = FirebaseFirestore.instance.collection('todos').doc(toUser);
  final List _data = await dbRef.get().then((value) => value.data()!['data']);
  _data[id] = {
    'id': id,
    'name': name ?? _data[id]['name'],
    'importance': importance ?? _data[id]['importance'],
    'description': description ?? _data[id]['description'],
    'duration': duration ?? _data[id]['duration'],
    'deadline': deadline ?? _data[id]['deadline'],
    'fromUser': fromUser ?? _data[id]['fromUser'],
    'toUser': toUser,
    'complete': complete ?? _data[id]['complete'],
  };
  await dbRef.set({'data': _data});
}
