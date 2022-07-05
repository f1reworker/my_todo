import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:my_todo_refresh/secondPages/edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .doc(Utils.userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var _data = (snapshot.data!.data() as Map);
            final List<Map<String, dynamic>> _notes = [];
            for (var element in _data.keys) {
              _notes.add(_data[element]);
            }
            _notes.sort(((a, b) => b['lastUpdate'].compareTo(a['lastUpdate'])));
            return Stack(fit: StackFit.expand, children: [
              GridView.builder(
                padding: const EdgeInsets.only(
                    top: 21, left: 10, right: 10, bottom: 20),
                itemCount: _notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 155 / 140,
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (BuildContext context, int index) => TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          EditNotePage(
                              TextEditingController(
                                  text: _notes[index]['name']),
                              TextEditingController(
                                  text: _notes[index]['text']),
                              _notes[index]['id'],
                              Utils.userId!),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 7, top: 10, right: 5),
                          child: Text(
                            _notes[index]['name'],
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Ubuntu'),
                          ),
                        ),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: CustomTheme().orange),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              _notes[index]['text'],
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Ubuntu'),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomTheme().orange, width: 1),
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                widthFactor: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(right: 20, bottom: 18))),
                  onPressed: () {
                    // context.read<DeadlineProvider>().changeDeadline(DateTime.now()
                    //     .add(const Duration(hours: 1))
                    //     .toUtc()
                    //     .millisecondsSinceEpoch);
                    // context.read<ImportanceProvider>().changeImportance(2);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            EditNotePage(
                                TextEditingController(text: 'Новая заметка'),
                                TextEditingController(),
                                _notes.length,
                                Utils.userId!),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                      child: const Icon(
                        MyTodo.edit_note,
                        size: 30.5,
                        color: Colors.white,
                      ),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: CustomTheme.lightTheme.colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)))),
                ),
              )
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        });
  }
}
