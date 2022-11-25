import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'transition/fade_route.dart';
import 'transition/slide_route.dart';

void navigatorPush(BuildContext context, Widget screen, {bool isFade = false}) {
  if (isFade) {
    Navigator.of(context).push(FadeRoute(page: screen));
  } else {
    if (!kIsWeb && Platform.isIOS) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: screen.runtimeType.toString()),
      ));
    } else {
      Navigator.of(context).push(SlideLeftRoute(page: screen));
    }
  }
}

void navigatorPushReplacement(BuildContext context, Widget screen) {
  if (!kIsWeb && Platform.isIOS) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => screen,
      settings: RouteSettings(name: screen.runtimeType.toString()),
    ));
  } else {
    Navigator.of(context).pushReplacement(SlideLeftRoute(page: screen));
  }
}

void navigatorPushAndRemoveUntil(BuildContext context, Widget screen,
    {Type? to}) {
  if (to == null) {
    Navigator.of(context)
        .pushAndRemoveUntil(FadeRoute(page: screen), (route) => false);
  } else {
    Navigator.of(context).pushAndRemoveUntil(FadeRoute(page: screen),
        (route) => route.settings.name == to.toString());
  }
}

void navigatorPopTo(BuildContext context, Type to) {
  print('to: ${to.toString()}');
  Navigator.of(context).popUntil((route) {
    return route.settings.name == to.toString();
  });
}

// void navigatorPushCode(BuildContext context, String code) {
//   print('navigatorPushCode $code');
// }
