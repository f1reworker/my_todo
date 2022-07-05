import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_refresh/backend/new_todo_provider.dart';
import 'package:my_todo_refresh/backend/update_todo.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:my_todo_refresh/secondPages/alert_dialod.dart';
import 'package:my_todo_refresh/secondPages/new_todo_page.dart';
import 'package:provider/provider.dart';

class AllTodosPage extends StatelessWidget {
  const AllTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('todos')
            .doc(Utils.userId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            final Map<String, dynamic> _data =
                snapshot.data!.data() as Map<String, dynamic>;
            final List<Map<String, dynamic>> _todos = [];
            for (var element in _data.keys) {
              _todos.add(_data[element]);
            }
            _todos.sort((a, b) {
              return a['complete'] ? 1 : -1;
            });

            return Stack(fit: StackFit.loose, children: [
              ListView.separated(
                  itemBuilder: (context, index) => index == 0
                      ? const SizedBox(
                          height: 5,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            onPressed: () async {
                              context.read<DeadlineProvider>().changeDeadline(
                                  _todos[index - 1]['deadline']);
                              context
                                  .read<ImportanceProvider>()
                                  .changeImportance(
                                      _todos[index - 1]['importance']);
                              showAlertDialog(
                                context,
                                _todos[index - 1]['id'],
                                _todos[index - 1]['toUser'],
                                _todos[index - 1]['complete'],
                                _todos[index - 1]['name'],
                                _todos[index - 1]['description'],
                                _todos[index - 1]['importance'],
                                _todos[index - 1]['fromUser'],
                                _todos[index - 1]['duration'],
                                _todos[index - 1]['deadline'],
                              );
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        updateTodo(
                                            _todos[index - 1]['id'],
                                            Utils.userId!,
                                            !_todos[index - 1]['complete'],
                                            _todos[index - 1]['name'],
                                            _todos[index - 1]['description'],
                                            _todos[index - 1]['importance'],
                                            _todos[index - 1]['fromUser'],
                                            _todos[index - 1]['duration'],
                                            _todos[index - 1]['deadline']);
                                      },
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero)),
                                      child: Container(
                                        height: 33,
                                        width: 33,
                                        decoration: BoxDecoration(
                                            color: _todos[index - 1]
                                                        ['complete'] ==
                                                    true
                                                ? _checkBorderColor(
                                                        _todos[index - 1]
                                                            ['importance'])
                                                    .withOpacity(0.7)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(16.5),
                                            border: Border.all(
                                                color: _checkBorderColor(
                                                    _todos[index - 1]
                                                        ['importance']),
                                                width: 4)),
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      //TODO: TextOverflow
                                      Text(
                                        _todos[index - 1]['name'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.fade,
                                            color: Color(0xFF0D0D0D),
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        _todos[index - 1]['description'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.fade,
                                            color: Color(0xFF0D0D0D),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              height: 60,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    _todos[index - 1]["complete"] == false
                                        ? BoxShadow(
                                            color: CustomTheme().indigo,
                                            blurRadius: 10)
                                        : const BoxShadow(
                                            color: Colors.transparent)
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  border: _todos[index - 1]["complete"] == false
                                      ? Border.all(
                                          color: CustomTheme().indigo, width: 2)
                                      : Border.all(
                                          color: const Color(0xFFBDBDBD))),
                            ),
                          ),
                        ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),
                  itemCount: _todos.length + 1),
              Align(
                widthFactor: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.only(right: 20, bottom: 18))),
                  onPressed: () {
                    context.read<DeadlineProvider>().changeDeadline(
                        DateTime.now()
                            .add(const Duration(hours: 1))
                            .toUtc()
                            .millisecondsSinceEpoch);
                    context.read<ImportanceProvider>().changeImportance(2);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            NewTodoPage(_todos.length),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                      child: const Icon(
                        MyTodo.add,
                        size: 29,
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

  Color _checkBorderColor(_importance) {
    switch (_importance) {
      case 0:
        return const Color(0xFF03E579);
      case 1:
        return const Color(0xFF03CAE5);
      case 2:
        return const Color(0xFFE5A603);
      case 3:
        return const Color(0xFFE103E5);
      default:
        return const Color(0xFFE5031E);
    }
  }
}
