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

//TODO: Поменять первый день недели в pickdate()
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    initSettings();
    return Future.value(true);
  });
}

Duration initialDelay() {
  Duration initialDelay;
  DateTime now = DateTime.now();
  if (now.hour < 8) {
    initialDelay =
        now.difference(DateTime(now.year, now.month, now.day, 8, 0, 0));
  } else {
    initialDelay =
        DateTime(now.year, now.month, now.day + 1, 8, 0, 0).difference(now);
  }
  return initialDelay;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().cancelAll();
  Workmanager().registerPeriodicTask('uniqueName', 'taskName',
      frequency: const Duration(hours: 24), initialDelay: initialDelay());
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final int? workday = prefs.getInt('workday');
  final String? userId = prefs.getString('userId');
  if (workday != null) {
    Utils.workday = workday;
  } else {
    Utils.workday = 420;
  }
  if (userId != null) {
    Utils.userId = userId;
    updateTodoForDay();
  }
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
