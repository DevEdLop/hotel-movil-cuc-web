import 'package:flutter/material.dart';

class MyAppStateUser with ChangeNotifier {
  dynamic currentUser;

  void setArgumentos(dynamic argumentos) {
    currentUser = argumentos;
    notifyListeners();
  }
}
