import 'package:flutter/cupertino.dart';
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
                      : BuildButtonTodo(
                          todos: _todos,
                          index: index,
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
}

class BuildButtonTodo extends StatefulWidget {
  final List<Map<String, dynamic>> todos;
  final int index;
  const BuildButtonTodo({required this.todos, required this.index, Key? key})
      : super(key: key);

  @override
  State<BuildButtonTodo> createState() => _BuildButtonTodoState();
}

class _BuildButtonTodoState extends State<BuildButtonTodo> {
  int myWidth = 20;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onHorizontalDragUpdate: (event) {
          print(event.primaryDelta);
          if (event.primaryDelta! < -10) {
            setState(() {
              myWidth = 60;
            });
          } else if (event.primaryDelta! > 10) {
            setState(() {
              myWidth = 20;
            });
          }
        },
        child: TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () async {
            context
                .read<DeadlineProvider>()
                .changeDeadline(widget.todos[widget.index - 1]['deadline']);
            context
                .read<ImportanceProvider>()
                .changeImportance(widget.todos[widget.index - 1]['importance']);
            showAlertDialog(
              context,
              widget.todos[widget.index - 1]['id'],
              widget.todos[widget.index - 1]['toUser'],
              widget.todos[widget.index - 1]['complete'],
              widget.todos[widget.index - 1]['name'],
              widget.todos[widget.index - 1]['description'],
              widget.todos[widget.index - 1]['importance'],
              widget.todos[widget.index - 1]['fromUser'],
              widget.todos[widget.index - 1]['duration'],
              widget.todos[widget.index - 1]['deadline'],
            );
          },
          child: Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      updateTodo(
                          widget.todos[widget.index - 1]['id'],
                          Utils.userId!,
                          !widget.todos[widget.index - 1]['complete'],
                          widget.todos[widget.index - 1]['name'],
                          widget.todos[widget.index - 1]['description'],
                          widget.todos[widget.index - 1]['importance'],
                          widget.todos[widget.index - 1]['fromUser'],
                          widget.todos[widget.index - 1]['duration'],
                          widget.todos[widget.index - 1]['deadline']);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                          color: widget.todos[widget.index - 1]['complete'] ==
                                  true
                              ? _checkBorderColor(widget.todos[widget.index - 1]
                                      ['importance'])
                                  .withOpacity(0.7)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16.5),
                          border: Border.all(
                              color: _checkBorderColor(
                                  widget.todos[widget.index - 1]['importance']),
                              width: 4)),
                    )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      //TODO: TextOverflow
                      Text(
                        widget.todos[widget.index - 1]['name'],
                        softWrap: false,
                        style: const TextStyle(
                            overflow: TextOverflow.fade,
                            color: Color(0xFF0D0D0D),
                            fontSize: 22,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        widget.todos[widget.index - 1]['description'],
                        style: const TextStyle(
                            overflow: TextOverflow.fade,
                            color: Color(0xFF0D0D0D),
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  //transformAlignment: Alignment.centerRight,
                  curve: Curves.linearToEaseOut,
                  width: myWidth.toDouble(),
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      deleteTodo(
                        widget.todos[widget.index - 1]['id'].toString(),
                        Utils.userId!,
                      );
                      setState(() {
                        myWidth = 20;
                      });
                    },
                    icon: const Icon(CupertinoIcons.trash),
                    color: myWidth == 60 ? Colors.black : Colors.transparent,
                  ),
                  //: null,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18)),
                      color: myWidth == 60
                          ? const Color.fromARGB(210, 253, 44, 29)
                          : Colors.transparent),
                )
              ],
            ),
            height: 60,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  widget.todos[widget.index - 1]["complete"] == false
                      ? BoxShadow(color: CustomTheme().indigo, blurRadius: 10)
                      : const BoxShadow(color: Colors.transparent)
                ],
                borderRadius: BorderRadius.circular(20),
                border: widget.todos[widget.index - 1]["complete"] == false
                    ? Border.all(color: CustomTheme().indigo, width: 2)
                    : Border.all(color: const Color(0xFFBDBDBD))),
          ),
        ),
      ),
    );
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
