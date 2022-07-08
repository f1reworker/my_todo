import 'package:flutter/material.dart';
import 'package:my_todo_refresh/backend/utils.dart';
import 'package:my_todo_refresh/custom_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _taskCount = 0;
  int _taskComplete = 0;
  int _taskFall = 0;

  void getStat() async {
    final Map<String, dynamic>? _allTodosMap = await FirebaseFirestore.instance
        .collection('todos')
        .doc(Utils.userId)
        .get()
        .then((value) => value.data());
    if (_allTodosMap != null) {
      final clock = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
      for (var element in _allTodosMap.keys) {
        if (element != 'todosForDay' && _allTodosMap[element]['show']) {
          _taskCount++;
          if (_allTodosMap[element]['deadline'] < clock) _taskFall++;
          if (_allTodosMap[element]['complete']) _taskComplete++;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getStat();
    super.initState();
  }

  double _value = Utils.workday! / 60;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 18),
            child: Text(
              'Мой рабочий день',
              style: TextStyle(
                  color: Color(0xFF0d0d0d),
                  fontSize: 22,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w500),
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(9, 16, 177, 1),
                      Color.fromRGBO(10, 188, 188, 0.52)
                    ])),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      '1',
                      style: TextStyle(
                          color: Color(0xFF0d0d0d),
                          fontSize: 14,
                          fontFamily: 'PT Sans',
                          fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                          showValueIndicator: ShowValueIndicator.never,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          disabledThumbColor:
                              const Color.fromRGBO(255, 255, 255, 0.55),
                          thumbColor: const Color.fromRGBO(255, 255, 255, 0.55),
                          thumbShape: const SliderThumbShape(thumbSize: 24),
                        ),
                        child: Slider(
                          min: 1,
                          max: 12,
                          value: _value,
                          onChanged: (val) async {
                            _value = val;
                            setState(() {});
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('workday', val.round() * 60);
                            Utils.workday = val.round() * 60;
                          },
                        ),
                      ),
                    ),
                    const Text(
                      '12',
                      style: TextStyle(
                          color: Color(0xFF0d0d0d),
                          fontSize: 14,
                          fontFamily: 'PT Sans',
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (6 +
                        (_value - 1) *
                            (MediaQuery.of(context).size.width - 98) /
                            11.0)),
                // height: 10,
                // width: 10,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Center(
                        child: Text(
                          '${_value.round()} ч',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'PT Sans',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      height: 23,
                      width: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.7),
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                            blurRadius: 0,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(80, 139, 194, 1),
                            offset: Offset(0, -1),
                            spreadRadius: 0,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                        size: const Size(20, 23), painter: DrawTriangleShape()),
                    const SizedBox(
                      height: 28,
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 45,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 15, bottom: 18),
                  child: Text(
                    'Моя статистика',
                    style: TextStyle(
                        color: Color(0xFF0d0d0d),
                        fontSize: 22,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Divider(
                  color: Color(0xff8F8F8F),
                  height: 3,
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 18, bottom: 20),
                  child: Text(
                    "Всего заданий: $_taskCount\nВыполненных заданий: $_taskComplete\nЗаданий с пропущенным дедлайном: $_taskFall",
                    softWrap: true,
                    style: const TextStyle(
                        color: Color(0xFF0d0d0d),
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 30, color: CustomTheme().indigo)
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class SliderThumbShape extends SliderComponentShape {
  final double thumbSize;

  const SliderThumbShape({this.thumbSize = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromWidth(thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    canvas.drawCircle(center, thumbSize / 2,
        Paint()..color = const Color.fromRGBO(255, 255, 255, 0.55));
    canvas.drawCircle(
        center,
        thumbSize / 2,
        Paint()
          ..color = const Color.fromRGBO(232, 232, 232, 0.46)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }
}

class DrawTriangleShape extends CustomPainter {
  late Paint painter;
  late Paint painterShadow;
  DrawTriangleShape() {
    painterShadow = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(0, 4),
        [
          const Color.fromRGBO(0, 0, 0, 0.25),
          Colors.transparent,
        ],
      );
    painter = Paint()
      ..color = const Color.fromRGBO(9, 96, 177, 0.7)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var pathShadow = Path();
    pathShadow.moveTo(0, 0);
    pathShadow.lineTo(size.width / 2 / (size.height / 4), 4);
    pathShadow.lineTo(size.width - size.width / 2 / (size.height / 4), 4);
    pathShadow.lineTo(size.width, 0);
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, painter);
    canvas.drawPath(pathShadow, painterShadow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
