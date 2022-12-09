import 'dart:async';

import 'package:flutter/material.dart';

class MyButtonBloc {
  final _myButtonStreamController = StreamController<bool>();

  Stream<bool> get myButtonStream => _myButtonStreamController.stream;
  bool isSelect = false;

  void onTapButton(VoidCallback onTap) {
    if (isSelect == false) {
      isSelect = true;
      _myButtonStreamController.add(isSelect);
      onTap();
    }

    Future.delayed(const Duration(seconds: 2), () {
      isSelect = false;
      _myButtonStreamController.add(isSelect);
    });
  }
}
