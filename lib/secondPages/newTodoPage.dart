// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo_refresh/backend/addTodo.dart';
import 'package:my_todo_refresh/backend/newTodoProvider.dart';
import 'package:my_todo_refresh/backend/pageProvider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewTodoPage extends StatelessWidget {
  NewTodoPage({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
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
          _buildInputText(_nameController, 'name', 1, null, 40),
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
          _buildInputText(_descriptionController, 'description', 5, null, 120),
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
            _buildCircle(const Color.fromRGBO(3, 229, 121, 0.7),
                const Color.fromRGBO(3, 229, 121, 1), 0, context),
            _buildCircle(const Color.fromRGBO(3, 202, 229, 0.7),
                const Color.fromRGBO(3, 202, 229, 1), 1, context),
            _buildCircle(const Color.fromRGBO(229, 166, 3, 0.7),
                const Color.fromRGBO(229, 166, 3, 1), 2, context),
            _buildCircle(const Color.fromRGBO(225, 3, 229, 0.7),
                const Color.fromRGBO(225, 3, 229, 1), 3, context),
            _buildCircle(const Color.fromRGBO(229, 3, 30, 0.7),
                const Color.fromRGBO(229, 3, 30, 1), 4, context),
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
                _buildInputText(_hoursController, 'duration', 1, 66, 33),
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
                _buildInputText(_minuteController, 'duration', 1, 66, 33),
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
          Container(
            padding: EdgeInsets.zero,
            height: 37,
            width: 335,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, style: BorderStyle.solid),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]),
            child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 7))),
                onPressed: () async {
                  final DateTime? datePicked = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: CustomTheme().indigo,
                              onPrimary: Colors.white,
                              onSurface: const Color(0xFF0D0D0D),
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                textStyle:
                                    const TextStyle(fontFamily: 'Ubuntu'),
                                primary: const Color(0xFF0d0d0d),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      helpText: ('Выберите дату'),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));

                  if (datePicked != null) {
                    final TimeOfDay? timePicked = await showTimePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: CustomTheme().indigo,
                                onPrimary: Colors.white,
                                onSurface: CustomTheme().blackIcon,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      const TextStyle(fontFamily: 'Ubuntu'),
                                  primary: const Color(0xFF0d0d0d),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialTime: TimeOfDay(
                            hour: TimeOfDay.now().hour,
                            minute: TimeOfDay.now().minute));
                    if (timePicked != null) {
                      context.read<DeadlineProvider>().changeDeadline(
                          datePicked.millisecondsSinceEpoch +
                              timePicked.hour * 3600000 +
                              timePicked.minute * 60000 +
                              timePicked.period.index * 12 * 3600);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd.MM.yyyy kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              context.watch<DeadlineProvider>().getDeadline)),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const Icon(
                      MyTodo.calendar,
                      color: Color(0xFF0d0d0d),
                    )
                  ],
                )),
          ),
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
                    onPressed: () async {
                      if (_nameController.text.isEmpty ||
                          _nameController.text == "") {
                        Fluttertoast.showToast(
                            msg: "Введите название",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if ((_hoursController.text.isEmpty ||
                              _hoursController.text == "") &&
                          (_minuteController.text.isEmpty ||
                              _minuteController.text == "")) {
                        Fluttertoast.showToast(
                            msg: "Введите время выполнения",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        int _time = 0;
                        if (_minuteController.text.isNotEmpty) {
                          _time += int.parse(_minuteController.text) * 60;
                        }
                        if (_hoursController.text.isNotEmpty) {
                          _time += int.parse(_hoursController.text) * 3600;
                        }
                        var result = await addTodo(
                            _nameController.text,
                            _descriptionController.text,
                            ImportanceProvider().getImportance,
                            21,
                            21,
                            _time,
                            (DeadlineProvider().getDeadline / 1000).ceil());
                        result == -1
                            ? Fluttertoast.showToast(
                                msg: "Что-то пошло не так, попробуйте позже",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0)
                            : context.read<PageProvider>().changePage(3);
                      }
                    },
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

  Widget _buildCircle(
      Color color, Color colorBorder, int importance, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9),
      child: TextButton(
        onPressed: () =>
            context.read<ImportanceProvider>().changeImportance(importance),
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        child: Icon(Icons.check,
            size: 18,
            color:
                context.watch<ImportanceProvider>().getImportance == importance
                    ? Colors.white
                    : Colors.transparent),
      ),
      height: 33,
      width: 33,
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: colorBorder, width: 4, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(16.5))),
    );
  }

  Widget _buildInputText(TextEditingController controller, String type,
      int minLines, double? width, double? height) {
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
        inputFormatters: type == 'duration'
            ? [
                LengthLimitingTextInputFormatter(2),
                FilteringTextInputFormatter.digitsOnly
              ]
            : null,
        textAlign: type == 'duration' ? TextAlign.center : TextAlign.start,
        scrollPadding: EdgeInsets.zero,
        toolbarOptions: const ToolbarOptions(
            copy: true, paste: true, cut: true, selectAll: true),
        minLines: minLines,
        maxLines: minLines,
        textAlignVertical: TextAlignVertical.center,
        keyboardType:
            type == 'duration' ? TextInputType.number : TextInputType.text,
        controller: controller,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
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
