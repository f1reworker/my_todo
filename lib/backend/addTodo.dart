// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_todo_refresh/backend/getTodos.dart';
import 'package:my_todo_refresh/config.dart';
import 'package:mysql1/mysql1.dart';

Future addTodo(String name, String description, int importance, int fromUser,
    int toUser, int duration, int deadline) async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: dbName,
        password: passwordUser));
    var result = await conn.query(
        'insert into usertodos (fromUser, toUser, name, description, importance, duration, deadline, complete) values (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          fromUser,
          toUser,
          name,
          description,
          importance,
          duration,
          deadline,
          0
        ]);

    if (result.insertId != null) TodosProvider().updateTodo(21, null, null);
    await conn.close();
  } catch (error) {
    if (kDebugMode) {
      print("error $error");
    }
    return -1;
  }
}
