// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/newTodoProvider.dart';
import 'package:my_todo_refresh/backend/pageProvider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';

class AllTodosPage extends StatelessWidget {
  const AllTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Align(
          widthFactor: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomRight,
          child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.only(right: 20, bottom: 18))),
            onPressed: () {
              context.read<DeadlineProvider>().changeDeadline(DateTime.now()
                  .add(const Duration(hours: 1))
                  .toUtc()
                  .millisecondsSinceEpoch);
              context.read<ImportanceProvider>().changeImportance(2);
              context.read<PageProvider>().changePage(1);
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
                    borderRadius: const BorderRadius.all(Radius.circular(30)))),
          ),
        ),
      ],
    );
  }
}
