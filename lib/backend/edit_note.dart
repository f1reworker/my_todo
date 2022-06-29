import 'package:cloud_firestore/cloud_firestore.dart';

void updateNote(
    String name, String text, int lastUpdate, String toUser, int id) async {
  final dbRef = FirebaseFirestore.instance.collection('notes').doc(toUser);
  await dbRef.update({
    id.toString(): {
      'name': name,
      'text': text,
      'lastUpdate': lastUpdate,
      'toUser': toUser,
      'id': id,
    }
  });
}
