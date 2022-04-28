// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

int _page = 2;

class PageProvider with ChangeNotifier {
  int get getPage => _page;
  void changePage(int page) {
    _page = page;
    notifyListeners();
  }
}
