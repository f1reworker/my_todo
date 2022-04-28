// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:my_todo_refresh/firstPages/allTodosPage.dart';
import 'package:my_todo_refresh/firstPages/homePage.dart';
import 'package:my_todo_refresh/firstPages/notes.dart';
import 'package:my_todo_refresh/firstPages/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AllTodosPage(),
    NotesPage(),
    ProfilePage(),
  ];

  // ignore: prefer_final_fields
  static List _appbarOptions = <PreferredSizeWidget>[
    buildAppBar(
      "Задачи на сегодня",
      CustomTheme().indigo,
      const SizedBox(),
    ),
    buildAppBar(
        "Все задачи",
        CustomTheme().indigo,
        const Icon(
          MyTodo.listdone,
          color: Colors.white,
          size: 26,
        )),
    buildAppBar(
        "Заметки",
        CustomTheme().orange,
        const Icon(
          MyTodo.edit_list,
          color: Colors.white,
          size: 30,
        )),
    buildAppBar(
        "Профиль",
        CustomTheme().purple,
        const Icon(
          MyTodo.user,
          color: Colors.white,
          size: 26,
        )),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.lightTheme.colorScheme.background,
        bottomNavigationBar: Container(
            height: 80,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                selectedIconTheme: IconThemeData(color: CustomTheme().redIcon),
                unselectedIconTheme:
                    IconThemeData(color: CustomTheme().blackIcon),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                onTap: _onItemTapped,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        MyTodo.home,
                        size: 27,
                      ),
                      label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        MyTodo.all_todos,
                        size: 27,
                      ),
                      label: "AllTodos"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        MyTodo.note,
                        size: 27,
                      ),
                      label: "Notes"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        MyTodo.user,
                        size: 27,
                      ),
                      label: "Profile"),
                ],
              ),
            )),
        appBar: _appbarOptions.elementAt(selectedIndex),
        body: _widgetOptions.elementAt(selectedIndex));
  }
}

PreferredSizeWidget buildAppBar(String title, Color color, Widget icon) {
  return PreferredSize(
      child: Container(
        height: 146,
        padding:
            const EdgeInsets.only(left: 24, top: 42, bottom: 27, right: 24),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white),
              ),
              icon
            ],
          ),
        ),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            color: color,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
      ),
      preferredSize: const Size.fromHeight(146));
}
