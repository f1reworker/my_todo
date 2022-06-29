import 'package:flutter/foundation.dart';

int _page = 0;

class PageProvider with ChangeNotifier {
  int get getPage => _page;
  void changePage(int page) {
    _page = page;
    notifyListeners();
  }
}
