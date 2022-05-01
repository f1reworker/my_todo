import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:my_todo_refresh/backend/auth.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _mailController = TextEditingController();
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mailController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future loginUser() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      dynamic result = await login(
          md5.convert(utf8.encode(_mailController.text)).toString(),
          md5.convert(utf8.encode(_textController.text)).toString());
      if (result == 0) {
        Fluttertoast.showToast(
            msg: "Неверный email или пароль!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return 0;
      } else if (result == -1) {
        Fluttertoast.showToast(
            msg: "Что-то пошло не так, попробуйте позже",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return -1;
      } else {
        if (kDebugMode) {
          print(result["id"]);
        }
        return result["id"];
      }
    }
  }

  Future auth() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      int result = await addUser(
          md5
              .convert(utf8.encode(_mailController.text.replaceAll(' ', '')))
              .toString(),
          md5.convert(utf8.encode(_textController.text)).toString());
      if (result == 0) {
        Fluttertoast.showToast(
            msg: "Пользователь с таким email уже есть!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (result == -1) {
        Fluttertoast.showToast(
            msg: "Что-то пошло не так, попробуйте позже",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        return result;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              top: (MediaQuery.of(context).size.height - 450) / 3,
              right: 16,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                  const Text(
                    'ДОБРО ПОЖАЛОВАТЬ В\n"_________"!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                  _buildInputText('e-mail', _mailController),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildInputText(
                    'пароль',
                    _textController,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: CustomTheme().indigo),
                      child: TextButton(
                        onPressed: () async {
                          await loginUser().then((value) {
                            if (value > 0) {
                              context.read<AuthProvider>().isLogIn(true);
                            }
                          });
                        },
                        child: const Text(
                          "ВОЙТИ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  TextButton(
                    onPressed: () async {
                      await auth().then((value) {
                        if (value != null) {
                          context.read<AuthProvider>().isLogIn(true);
                        }
                      });
                    },
                    child: const Text(
                      "ЗАРЕГИСТРИРОВАТЬСЯ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  StatefulWidget _buildInputText(
      String hintText, TextEditingController controller) {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,
      toolbarOptions: const ToolbarOptions(
          copy: true, paste: true, cut: true, selectAll: true),
      minLines: 1,
      maxLines: 1,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "поле  не заполнено";
        } else if (hintText == "e-mail") {
          if (!EmailValidator.validate(value!)) return "почта некорректна";
        } else if (hintText == "пароль") {
          if (value!.length < 6) return "пароль меньше 6 символов";
        }
        return null;
      },
      obscureText: hintText == "пароль" && !_showPassword ? true : false,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          suffixIcon: hintText == "пароль"
              ? GestureDetector(
                  onTap: () {
                    _togglevisibility();
                  },
                  child: Icon(
                    _showPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black87,
                  ),
                )
              : null,
          hoverColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
