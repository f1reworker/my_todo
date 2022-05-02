// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/getTodos.dart';
import 'package:my_todo_refresh/backend/newTodoProvider.dart';
import 'package:my_todo_refresh/backend/pageProvider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';

class AllTodosPage extends StatefulWidget {
  const AllTodosPage({Key? key}) : super(key: key);

  @override
  State<AllTodosPage> createState() => _AllTodosPageState();
}

class _AllTodosPageState extends State<AllTodosPage> {
  late Future<List> _todos;

  @override
  void initState() {
    _todos = getTodos(21);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        FutureBuilder<List>(
          future: _todos,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.first == -1) {
                return const Text('Что-то пошло не так, попробуйте позже');
              } else if (snapshot.data?.first == 0) {
                return const Text('Нет задач');
              } else {
                return ListView.separated(
                    itemBuilder: (context, index) => index == 0
                        ? const SizedBox(
                            height: 5,
                          )
                        : _buildTask(snapshot.data![index - 1]),
                    separatorBuilder: (context, index) => const Divider(
                          height: 24,
                          color: Colors.transparent,
                        ),
                    itemCount: snapshot.data!.length + 1);
              }
            } else {
              return const Text('Загрузка данных');
            }
          },
        ),
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

  Widget _buildTask(_task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => {},
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Container(
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.5),
                      border: Border.all(
                          color: _checkBorderColor(_task['importance']),
                          width: 4)),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _task['name'],
                  style: const TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontSize: 22,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  _task['description'],
                  style: const TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                )
              ],
            )
          ],
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              _task["complete"] == 0
                  ? BoxShadow(color: CustomTheme().indigo, blurRadius: 10)
                  : const BoxShadow(color: Colors.transparent)
            ],
            borderRadius: BorderRadius.circular(20),
            border: _task["complete"] == 0
                ? Border.all(color: CustomTheme().indigo, width: 2)
                : Border.all(color: const Color(0xFFBDBDBD))),
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
