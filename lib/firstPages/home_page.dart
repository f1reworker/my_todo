import 'package:flutter/material.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        Icon(MyTodo.add, color: Colors.red),
        Icon(MyTodo.add_rounded, color: Colors.red),
        Icon(MyTodo.all_todos, color: Colors.red),
        Icon(MyTodo.calendar, color: Colors.red),
        Icon(MyTodo.close, color: Colors.red),
        Icon(MyTodo.edit_list, color: Colors.red),
        Icon(MyTodo.edit_note, color: Colors.red),
        Icon(MyTodo.home, color: Colors.red),
        Icon(MyTodo.listdone, color: Colors.red),
        Icon(MyTodo.note, color: Colors.red),
      ],
    );
  }
}
