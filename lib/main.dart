import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/new_todo_provider.dart';
import 'package:my_todo_refresh/backend/page_provider.dart';
import 'package:my_todo_refresh/backend/todo_for_day.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/firstPages/landing.dart';
import 'package:my_todo_refresh/firstPages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    initSettings();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().cancelAll();
  Workmanager().registerPeriodicTask('uniqueName', 'taskName',
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 10));
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');
  if (userId != null) Utils.userId = userId;
  runApp(MultiProvider(providers: [
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
        home: Utils.userId != null
            ? MyHomePage(
                index: page,
              )
            : const LandingPage());
  }
}
