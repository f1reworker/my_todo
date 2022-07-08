import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_refresh/backend/page_provider.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/main.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';

final List<String> addedTodo = [];

class AddTodoForDay extends StatelessWidget {
  const AddTodoForDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    addedTodo.clear();
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            height: 116,
            padding:
                const EdgeInsets.only(left: 24, top: 42, bottom: 27, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Выберите задачи",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Colors.white),
                ),
                IconButton(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(bottom: 3),
                    onPressed: () async {
                      final Map<String, dynamic>? _allTodosMap =
                          await FirebaseFirestore.instance
                              .collection('todos')
                              .doc(Utils.userId)
                              .get()
                              .then((value) => value.data());
                      if (_allTodosMap == null) {
                        await FirebaseFirestore.instance
                            .collection('todos')
                            .doc(Utils.userId)
                            .update({'todosForDay': addedTodo});
                      } else {
                        final List _todoForDay =
                            _allTodosMap['todosForDay'] ?? [];
                        addedTodo.toSet();
                        addedTodo.toList();
                        _todoForDay.addAll(addedTodo);
                        await FirebaseFirestore.instance
                            .collection('todos')
                            .doc(Utils.userId)
                            .update({'todosForDay': _todoForDay});
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      MyTodo.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ))
              ],
            ),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                color: CustomTheme().indigo,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
          ),
          preferredSize: const Size.fromHeight(116)),
      bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              selectedIconTheme: IconThemeData(color: CustomTheme().blackIcon),
              unselectedIconTheme:
                  IconThemeData(color: CustomTheme().blackIcon),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const MyApp(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                context.read<PageProvider>().changePage(index);
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      MyTodo.home,
                      size: 27,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyTodo.all_todos,
                      size: 27,
                    ),
                    label: "AllTodos"),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyTodo.note,
                      size: 27,
                    ),
                    label: "Notes"),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyTodo.user,
                      size: 27,
                    ),
                    label: "Profile"),
              ],
            ),
          )),
      body: StreamBuilder(
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
              final List _data2 = _data['todosForDay'] ?? [];
              for (var element in _data.keys) {
                if (element != 'todosForDay' &&
                    _data[element]['show'] &&
                    !_data[element]['complete'] &&
                    !(_data2).contains(element)) {
                  _todos.add(_data[element]);
                }
              }
              return ListView.separated(
                  itemBuilder: (context, index) =>
                      index == 0 || index == _todos.length + 1
                          ? const SizedBox(
                              height: 5,
                            )
                          : BuildButtonTodo(
                              key: UniqueKey(),
                              todos: _todos,
                              index: index,
                            ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),
                  itemCount: _todos.length + 1);
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
          }),
    );
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
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onHorizontalDragUpdate: (event) {
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
        child: Container(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12, right: 14),
                height: 33,
                width: 33,
                child: Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) =>
                        _checkBorderColor(
                            widget.todos[widget.index - 1]['importance'])),
                    activeColor: _checkBorderColor(
                        widget.todos[widget.index - 1]['importance']),
                    value: _added,
                    onChanged: (value) => setState(() {
                          if (!_added) {
                            addedTodo.add(widget.todos[widget.index - 1]['id']
                                .toString());
                          } else {
                            addedTodo.remove(widget.todos[widget.index - 1]
                                    ['id']
                                .toString());
                          }
                          _added = !_added;
                        })),
              ),
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
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          height: 60,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: CustomTheme().indigo, blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: CustomTheme().indigo, width: 2)),
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
