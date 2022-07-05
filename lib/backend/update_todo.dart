import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future updateTodo(
  int id,
  String toUser,
  bool complete,
  String name,
  String description,
  int importance,
  String fromUser,
  int duration,
  int deadline,
) async {
  final dbRef = FirebaseFirestore.instance.collection('todos').doc(toUser);
  dbRef.update({
    id.toString(): {
      'show': true,
      'id': id,
      'name': name,
      'importance': importance,
      'description': description,
      'duration': duration,
      'deadline': deadline,
      'fromUser': fromUser,
      'toUser': toUser,
      'complete': complete,
    }
  });
}

Future deleteTodo(String id, String toUser) async {
  final dbRef = FirebaseFirestore.instance.collection('todos').doc(toUser);
  dbRef.update({'$id.show': false});
}
