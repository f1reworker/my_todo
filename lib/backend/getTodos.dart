// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_todo_refresh/config.dart';
import 'package:mysql1/mysql1.dart';

Future<List> getTodosFunc(int id, int? idTodo, int? complete) async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: dbName,
        password: passwordUser));

    Results results = await conn.query(
        'select id, fromUser, toUser, name, description, importance, duration, deadline, complete from usertodos where toUser = ?',
        [id]);
    await conn.close();
    if (results.isNotEmpty) {
      List _todos = [];
      _todos.addAll(
          results.where((element) => element['complete'] == 0).toList());
      _todos.addAll(
          results.where((element) => element['complete'] == 1).toList());
      return _todos;
    } else {
      return [0];
    }
  } catch (error) {
    if (kDebugMode) {
      print("error $error");
    }
    return [-1];
  }
}

Future<List> updateTodos(int userId, int? idTodo, int? complete) async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: dbName,
        password: passwordUser));
    if (idTodo != null && complete != null) {
      await conn.query(
          'update usertodos set complete = ? where id=? and toUser=?',
          [complete, idTodo, userId]);
    }
    Results results = await conn.query(
        'select id, fromUser, toUser, name, description, importance, duration, deadline, complete from usertodos where toUser = ?',
        [userId]);
    await conn.close();
    if (results.isNotEmpty) {
      List _todos = [];
      _todos.addAll(
          results.where((element) => element['complete'] == 0).toList());
      _todos.addAll(
          results.where((element) => element['complete'] == 1).toList());
      return _todos;
    } else {
      return [0];
    }
  } catch (error) {
    if (kDebugMode) {
      print("error $error");
    }
    return [-1];
  }
}

List _todos = [];

class TodosProvider with ChangeNotifier {
  List get getTodos => _todos;
  void updateTodo(int idUser, int? idTodo, int? complete) async {
    List todos = await updateTodos(idUser, idTodo, complete);
    _todos = todos;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
  }
}
