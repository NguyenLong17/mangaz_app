import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressDialog {
  bool _isShow = false;
  final BuildContext context;

  ProgressDialog(this.context);

  void show() {
    if (_isShow) {
      return;
    }
    _isShow = true;
    Future.delayed(Duration.zero, () {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (_, __, ___) {
          return Container(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Lottie.asset('assets/animation/loading.json'),
            ),
          );
        },
      );
    });
  }

  void hide() {
    if(_isShow) {
      _isShow = false;
      Navigator.of(context).pop();
    }
  }
}
