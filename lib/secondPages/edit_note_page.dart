import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/edit_note.dart';
import 'package:my_todo_refresh/backend/page_provider.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:my_todo_refresh/main.dart';
import 'package:my_todo_refresh/my_todo_icons.dart';
import 'package:provider/provider.dart';

class EditNotePage extends StatelessWidget {
  final TextEditingController _nameController;
  final TextEditingController _textController;
  final int _id;
  final String _toUser;
  const EditNotePage(
      this._nameController, this._textController, this._id, this._toUser,
      {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!(_nameController.text == 'Новая заметка' &&
            _textController.text == '')) {
          updateNote(
              _nameController.text,
              _textController.text,
              (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
              _toUser,
              _id);
        }
        return true;
      },
      child: Scaffold(
        body: Container(
          child: TextFormField(
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(0, 0, 0, 0.8)),
            decoration: const InputDecoration(
              hintText: 'Поле для текста',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              border: InputBorder.none,
            ),
            showCursor: true,
            cursorColor: Colors.grey,
            expands: true,
            minLines: null,
            maxLines: null,
            controller: _textController,
          ),
          margin: const EdgeInsets.fromLTRB(20, 29, 20, 31),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFCF7330),
                  blurRadius: 30,
                )
              ]),
        ),
        bottomNavigationBar: Container(
            height: 60,
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
                selectedIconTheme:
                    IconThemeData(color: CustomTheme().blackIcon),
                unselectedIconTheme:
                    IconThemeData(color: CustomTheme().blackIcon),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  if (!(_nameController.text == 'Новая заметка' &&
                      _textController.text == '')) {
                    updateNote(
                        _nameController.text,
                        _textController.text,
                        (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
                        _toUser,
                        _id);
                  }
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const MyApp(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  context.read<PageProvider>().changePage(index);
                },
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
        appBar: PreferredSize(
            child: Container(
              height: 116,
              padding: const EdgeInsets.only(
                  left: 24, top: 42, bottom: 27, right: 24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        //inputFormatters: [LengthLimitingTextInputFormatter(14)],
                        minLines: 1,
                        maxLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white),
                        controller: _nameController,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (!(_nameController.text == 'Новая заметка' &&
                              _textController.text == '')) {
                            updateNote(
                                _nameController.text,
                                _textController.text,
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .ceil(),
                                _toUser,
                                _id);
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          MyTodo.edit_list,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
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
                  color: CustomTheme().orange,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            preferredSize: const Size.fromHeight(116)),
      ),
    );
  }
}
