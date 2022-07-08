import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/todo_for_day.dart';
import 'package:my_todo_refresh/backend/update_todo.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_refresh/secondPages/add_todo_for_day.dart';
import 'package:my_todo_refresh/secondPages/alert_dialod.dart';
import 'package:my_todo_refresh/secondPages/new_todo_page.dart';
import 'package:provider/provider.dart';
import 'package:my_todo_refresh/backend/new_todo_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            final List _ids = _data['todosForDay'] ?? [];
            for (var element in _data.keys) {
              if (element != 'todosForDay' &&
                  _data[element]['show'] &&
                  _ids.contains(element)) {
                _todos.add(_data[element]);
              }
            }
            _todos.sort((a, b) {
              return a['complete'] ? 1 : -1;
            });

            return Stack(fit: StackFit.loose, children: [
              ListView.separated(
                  itemBuilder: (context, index) =>
                      index == 0 || index == _todos.length + 1
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
                  itemCount: _todos.length + 2),
              Align(
                widthFactor: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                child: ButtonAddTodo(newId: _data.length),
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

class ButtonAddTodo extends StatefulWidget {
  final int newId;
  const ButtonAddTodo({required this.newId, Key? key}) : super(key: key);

  @override
  State<ButtonAddTodo> createState() => _ButtonAddTodoState();
}

class _ButtonAddTodoState extends State<ButtonAddTodo> {
  bool _openButton = false;
  Icon _myIcon = const Icon(
    MyTodo.add,
    size: 29,
    color: Colors.white,
  );
  void changeButton() {
    setState(() {
      if (_openButton) {
        _openButton = !_openButton;

        _myIcon = const Icon(
          MyTodo.add,
          size: 29,
          color: Colors.white,
        );
      } else {
        _openButton = !_openButton;
        _myIcon = const Icon(
          MyTodo.close,
          size: 29,
          color: Colors.white,
        );
      }
    });
  }

  @override
  void initState() {
    _openButton = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        child: !_openButton
            ? Padding(
                padding: const EdgeInsets.only(bottom: 18, right: 24),
                child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: CustomTheme.lightTheme.colorScheme.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    child: Center(
                        child: TextButton(
                      onPressed: changeButton,
                      child: _myIcon,
                    ))),
              )
            : Container(
                margin: const EdgeInsets.only(bottom: 13, right: 19),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Color(0xFFACABAB))
                    ],
                    color: Colors.white),
                height: 187,
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        padding: const EdgeInsets.only(top: 25, bottom: 24),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const AddTodoForDay(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        },
                        icon: Icon(
                          MyTodo.all_todos,
                          size: 28,
                          color: CustomTheme().blackIcon,
                        )),
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 25),
                        onPressed: () {
                          updateTodoForDayByHomePage(widget.newId.toString());
                          context.read<DeadlineProvider>().changeDeadline(
                              DateTime.now()
                                  .add(const Duration(hours: 1))
                                  .toUtc()
                                  .millisecondsSinceEpoch);
                          context
                              .read<ImportanceProvider>()
                              .changeImportance(2);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  NewTodoPage(widget.newId),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        icon: Icon(
                          MyTodo.add,
                          size: 28,
                          color: CustomTheme().blackIcon,
                        )),
                    Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: CustomTheme.lightTheme.colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        child: Center(
                            child: TextButton(
                          onPressed: changeButton,
                          child: _myIcon,
                        ))),
                  ],
                ),
              ));
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
  int myWidth = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onHorizontalDragUpdate: (event) {
          if (event.primaryDelta! > 10) {
            setState(() {
              myWidth = 50;
            });
          } else if (event.primaryDelta! < -10) {
            setState(() {
              myWidth = 0;
            });
          }
        },
        child: TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () async {
            context.read<DeadlineProvider>().changeDeadline(
                widget.todos[widget.index - 1]['deadline'] * 1000);
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  //transformAlignment: Alignment.centerRight,
                  curve: Curves.linear,
                  width: myWidth.toDouble(),
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      deleteTodoForDay(
                        widget.todos[widget.index - 1]['id'].toString(),
                      );
                      setState(() {
                        myWidth = 0;
                      });
                    },
                    icon: const Icon(
                      Icons.visibility_off_outlined,
                      size: 29,
                    ),
                    color: myWidth == 50 ? Colors.black : Colors.transparent,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18)),
                      color: myWidth == 50
                          ? const Color.fromARGB(210, 253, 44, 29)
                          : Colors.transparent),
                ),
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
                        softWrap: false,
                        style: const TextStyle(
                            overflow: TextOverflow.fade,
                            color: Color(0xFF0D0D0D),
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
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
