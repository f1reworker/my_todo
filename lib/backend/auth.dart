import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_todo_refresh/config.dart';
import 'package:mysql1/mysql1.dart';

Future addUser(String email, String password) async {
  // Open a connection (testdb should already exist)
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: dbName,
        password: passwordUser));

    // Create a table
    // await conn.query(
    //     'CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, email varchar(255),password varchar(255), dateAuth int)');
    // await conn.query(
    //     'CREATE TABLE userTodos (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, fromUser int NOT NULL, toUser int NOT NULL, name varchar(255) NOT NULL, description varchar(255), importance int NOT NULL, duration int, deadline int)');
    var results =
        await conn.query('select id from users where email = ?', [email]);
    if (results.isNotEmpty) return 0;
    var result = await conn.query(
        'insert into users (email, password, dateAuth) values (?, ?, ?)', [
      email,
      password,
      (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).ceil()
    ]);

    if (result.insertId != null) return result.insertId;

    // Query the database using a parameterized query
    // var results = await conn.query(
    //     'select name, email, age from users where id = ?', [result.insertId]);
    // for (var row in results) {
    //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    // }

    // // Update some data
    // await conn.query('update users set age=? where name=?', [26, 'Bob']);

    // // Query again database using a parameterized query
    // var results2 = await conn.query(
    //     'select name, email, age from users where id = ?', [result.insertId]);
    // for (var row in results2) {
    //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    // }

    // Finally, close the connection
    await conn.close();
  } catch (error) {
    if (kDebugMode) {
      print("error $error");
    }
    return -1;
  }
}

Future login(String email, String password) async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: dbName,
        password: passwordUser));

    var results = await conn.query(
        'select id from users where email = ? && password = ? ',
        [email, password]);
    await conn.close();
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return 0;
    }
  } catch (error) {
    if (kDebugMode) {
      print("error $error");
    }
    return -1;
  }
}

bool _data1 = true;

class AuthProvider with ChangeNotifier {
  bool get isLogggedIn => _data1;
  void isLogIn(bool isLoggedIn) {
    _data1 = isLoggedIn;
    notifyListeners();
  }
}
