// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_todo_refresh/config.dart';
import 'package:mysql1/mysql1.dart';

Future<List> getTodos(int id) async {
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
      return results.toList();
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
