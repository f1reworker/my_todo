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
