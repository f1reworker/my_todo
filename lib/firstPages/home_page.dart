import 'package:flutter/material.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          IconButton(
              onPressed: () {
                // Workmanager().registerOneOffTask('uniqueName', 'taskName',
                //     initialDelay: const Duration(seconds: 5));
              },
              icon: const Icon(Icons.ac_unit_outlined)),
          const Icon(MyTodo.add, color: Colors.red),
          const Icon(MyTodo.add_rounded, color: Colors.red),
          const Icon(MyTodo.all_todos, color: Colors.red),
          const Icon(MyTodo.calendar, color: Colors.red),
          const Icon(MyTodo.close, color: Colors.red),
          const Icon(MyTodo.edit_list, color: Colors.red),
          const Icon(MyTodo.edit_note, color: Colors.red),
          const Icon(MyTodo.home, color: Colors.red),
          const Icon(MyTodo.listdone, color: Colors.red),
          const Icon(MyTodo.note, color: Colors.red),
        ],
      ),
    );
  }
}
