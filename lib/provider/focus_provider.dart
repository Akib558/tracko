import 'package:flutter/material.dart';

class FocusProvider with ChangeNotifier {
  List<dynamic> _habitsList = [];

  List<dynamic> get habitsList => _habitsList;

  void setHabitsListOnProviderClass(List<dynamic> demo) {
    _habitsList = demo;
  }

  void updateCircularIndicatorValue(int index, double value, int a, int b) {
    _habitsList[index][0] = value;
    _habitsList[index][1] = a;
    _habitsList[index][2] = b;

    notifyListeners();
  }
}
