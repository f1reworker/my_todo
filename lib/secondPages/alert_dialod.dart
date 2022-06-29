import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo_refresh/backend/new_todo_provider.dart';
import 'package:my_todo_refresh/backend/update_todo.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BuildAlert extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _descriptionController;
  final int id;
  final String toUser;
  final String fromUser;
  final TextEditingController _hoursController;
  final TextEditingController _minuteController;
  final int deadline;
  final int importance;
  const BuildAlert(
      this._nameController,
      this._descriptionController,
      this.id,
      this.toUser,
      this.fromUser,
      this._hoursController,
      this._minuteController,
      this.deadline,
      this.importance,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListView(shrinkWrap: true, primary: true,
          //TODO: вылеззает за рамки (Divider, deadline)
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 10),
                  child: TextFormField(
                    showCursor: true,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    controller: _nameController,
                  ),
                )),
                IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    onPressed: () {
                      updateTodo(id, toUser,
                          name: _nameController.text,
                          duration:
                              (int.tryParse(_hoursController.text) ?? 0) * 60 +
                                  (int.tryParse(_minuteController.text) ?? 0),
                          description: _descriptionController.text,
                          importance: ImportanceProvider().getImportance,
                          deadline: DeadlineProvider().getDeadline);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      MyTodo.add_rounded,
                      size: 25,
                      color: CustomTheme().blackIcon,
                    ))
              ],
            ),
            Divider(
                height: 3,
                thickness: 3,
                indent: 0,
                endIndent: 0,
                color: CustomTheme().grayDivider),
            const Padding(
              padding: EdgeInsets.only(left: 29, top: 18),
              child: Text(
                "Важность задачи",
                style: TextStyle(
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
              BuildCircle(
                Color.fromRGBO(3, 229, 121, 0.7),
                Color.fromRGBO(3, 229, 121, 1),
                0,
              ),
              BuildCircle(
                Color.fromRGBO(3, 202, 229, 0.7),
                Color.fromRGBO(3, 202, 229, 1),
                1,
              ),
              BuildCircle(
                Color.fromRGBO(229, 166, 3, 0.7),
                Color.fromRGBO(229, 166, 3, 1),
                2,
              ),
              BuildCircle(
                Color.fromRGBO(225, 3, 229, 0.7),
                Color.fromRGBO(225, 3, 229, 1),
                3,
              ),
              BuildCircle(
                Color.fromRGBO(229, 3, 30, 0.7),
                Color.fromRGBO(229, 3, 30, 1),
                4,
              ),
            ]),
            const SizedBox(
              height: 19,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 29),
              child: Text(
                "Время выполнения",
                style: TextStyle(
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    "Часы",
                    style: TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildInputText(_hoursController, 'duration', 1, 61, 30),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Минуты",
                    style: TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildInputText(_minuteController, 'duration', 1, 61, 30),
                ]),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 29, bottom: 12),
              child: Text(
                "Дедлайн",
                style: TextStyle(
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              child: const BuildDeadline(),
              padding: EdgeInsets.only(
                left: 16,
                right: MediaQuery.of(context).size.width - 16 - 219,
              ),
              width: 219,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 29, bottom: 12),
              child: Text(
                "Описание",
                style: TextStyle(
                  color: Color(0xFF0D0D0D),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: _buildInputText(
                  _descriptionController, 'description', 5, null, null),
            )
          ]),
      backgroundColor: CustomTheme.lightTheme.colorScheme.background,
    );
  }
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
        showCursor: true,
        cursorColor: Colors.grey,
        //focusNode: FocusNode(),
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
      ));
}

showAlertDialog(
  BuildContext context,
  int id,
  String toUser,
  String name,
  String description,
  int importance,
  String fromUser,
  int duration,
  int deadline,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final int _hours = (duration / 60).floor();
      final int _minute = duration - _hours * 60;
      return BuildAlert(
          TextEditingController(text: name),
          TextEditingController(text: description),
          id,
          toUser,
          fromUser,
          TextEditingController(text: _hours.toString()),
          TextEditingController(text: _minute.toString()),
          deadline,
          importance);
    },
  );
}

class BuildDeadline extends StatelessWidget {
  const BuildDeadline({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 37,
      width: 219,
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
                          textStyle: const TextStyle(fontFamily: 'Ubuntu'),
                          primary: const Color(0xFF0d0d0d),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
                helpText: ('Выберите дату'),
                context: context,
                initialDate: DateTime.fromMillisecondsSinceEpoch(
                    DeadlineProvider().getDeadline * 1000),
                firstDate: DateTime.fromMillisecondsSinceEpoch(min(
                    DeadlineProvider().getDeadline * 1000,
                    DateTime.now().millisecondsSinceEpoch)),
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
                            textStyle: const TextStyle(fontFamily: 'Ubuntu'),
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
                    (datePicked.millisecondsSinceEpoch / 1000).ceil() +
                        timePicked.hour * 3600 +
                        timePicked.minute * 60 +
                        timePicked.period.index * 12 * 3600);
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd.MM.yyyy kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(
                  context.watch<DeadlineProvider>().getDeadline * 1000,
                )),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const Icon(
                MyTodo.calendar,
                color: Color(0xFF0d0d0d),
              )
            ],
          )),
    );
  }
}

class BuildCircle extends StatelessWidget {
  const BuildCircle(this.color, this.colorBorder, this.importance, {Key? key})
      : super(key: key);
  final Color color;
  final Color colorBorder;
  final int importance;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: importance == 0
          ? const EdgeInsets.only(left: 16)
          : const EdgeInsets.only(left: 20),
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
}
