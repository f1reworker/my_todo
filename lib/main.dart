import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/auth.dart';
import 'package:my_todo_refresh/backend/newTodoProvider.dart';
import 'package:my_todo_refresh/backend/pageProvider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/firstPages/landing.dart';
import 'package:my_todo_refresh/firstPages/mainPage.dart';
import 'package:my_todo_refresh/secondPages/editNotePage.dart';
import 'package:my_todo_refresh/secondPages/newTodoPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<PageProvider>(create: (_) => PageProvider()),
    ChangeNotifierProvider<DeadlineProvider>(create: (_) => DeadlineProvider()),
    ChangeNotifierProvider<ImportanceProvider>(
        create: (_) => ImportanceProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int page = context.watch<PageProvider>().getPage;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme,
      home: context.watch<AuthProvider>().isLogggedIn
          ? page > 1
              ? MyHomePage(
                  index: page - 2,
                )
              : page == 1
                  ? NewTodoPage()
                  : const EditNotePage()
          : const LandingPage(),
    );
  }
}
