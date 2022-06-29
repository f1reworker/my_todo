import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/auth.dart';
import 'package:my_todo_refresh/backend/get_todos.dart';
import 'package:my_todo_refresh/backend/new_todo_provider.dart';
import 'package:my_todo_refresh/backend/page_provider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/firstPages/landing.dart';
import 'package:my_todo_refresh/firstPages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

const myId = '6EOYHqRqqfMVh64JUbAwhEnSFpd2';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<PageProvider>(create: (_) => PageProvider()),
    ChangeNotifierProvider<DeadlineProvider>(create: (_) => DeadlineProvider()),
    ChangeNotifierProvider<TodosProvider>(create: (_) => TodosProvider()),
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
            ? MyHomePage(
                index: page,
              )
            : const LandingPage());
  }
}
