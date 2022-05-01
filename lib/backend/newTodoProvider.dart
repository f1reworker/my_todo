// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

int _deadline =
    DateTime.now().add(const Duration(hours: 1)).toUtc().millisecondsSinceEpoch;

class DeadlineProvider with ChangeNotifier {
  int get getDeadline => _deadline;
  void changeDeadline(int deadline) {
    _deadline = deadline;
    notifyListeners();
  }
}

int _importance = 2;

class ImportanceProvider with ChangeNotifier {
  int get getImportance => _importance;
  void changeImportance(int importance) {
    _importance = importance;
    notifyListeners();
  }
}
