// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/pageProvider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';

class NewTodoPage extends StatelessWidget {
  const NewTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(
            height: 22,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              "Введите название",
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(
            height: 12.5,
          ),
          _buildInputText(TextEditingController(), true, 1, null, null, null),
          const SizedBox(
            height: 20.5,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              "Добавьте описание",
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _buildInputText(TextEditingController(), false, 5, null, null, null),
          const SizedBox(
            height: 23,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              "Важность задачи",
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _buildCircle(const Color(0xFF03E579), const Color(0x00000000), 0),
            _buildCircle(const Color(0xFF03CAE5), const Color(0x00000000), 1),
            _buildCircle(const Color(0xFFE5A603), const Color(0x00000000), 2),
            _buildCircle(const Color(0xFFE103E5), const Color(0x00000000), 3),
            _buildCircle(const Color(0xFFE5031E), const Color(0x00000000), 4),
          ]),
          const SizedBox(
            height: 19,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              "Время выполнения",
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 9,
                ),
                const Text(
                  "Часы",
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                _buildInputText(TextEditingController(), true, 1, 66, 33, null),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Минуты",
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                _buildInputText(TextEditingController(), true, 1, 66, 33, null),
              ]),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 9),
            child: Text(
              "Дедлайн",
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 19,
          ),
          _buildInputText(TextEditingController(), true, 1, null, null,
              const Icon(MyTodo.calendar)),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      backgroundColor: CustomTheme.lightTheme.colorScheme.background,
      appBar: PreferredSize(
          child: Container(
            height: 146,
            padding:
                const EdgeInsets.only(left: 24, top: 42, bottom: 27, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Новая задача",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white),
                ),
                IconButton(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(bottom: 3),
                    onPressed: () => context.read<PageProvider>().changePage(3),
                    icon: const Icon(
                      MyTodo.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ))
              ],
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
                color: CustomTheme().indigo,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
          ),
          preferredSize: const Size.fromHeight(146)),
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
              selectedIconTheme: IconThemeData(color: CustomTheme().blackIcon),
              unselectedIconTheme:
                  IconThemeData(color: CustomTheme().blackIcon),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              onTap: (index) =>
                  context.read<PageProvider>().changePage(index + 2),
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
    );
  }

  Widget _buildCircle(Color color, Color colorBorder, int importance) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9),
      // child: IconButton(
      //   onPressed: () {},
      //   padding: EdgeInsets.zero,
      //   icon: const Icon(
      //     MyTodo.add_rounded,
      //     size: 18,
      //   ),
      // ),
      height: 33,
      width: 33,
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: colorBorder, width: 4, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(16.5))),
    );
  }

  Widget _buildInputText(TextEditingController controller, bool isName,
      int minLines, double? width, double? height, Icon? suffixIcon) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          spreadRadius: 0,
          blurRadius: 2,
          offset: Offset(0, 2),
        )
      ], borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextFormField(
        scrollPadding: EdgeInsets.zero,
        toolbarOptions: const ToolbarOptions(
            copy: true, paste: true, cut: true, selectAll: true),
        minLines: minLines,
        maxLines: minLines,
        validator: (value) {
          if (isName && value != null && value.isEmpty) {
            return "введите название";
          }
          return null;
        },
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            hoverColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
