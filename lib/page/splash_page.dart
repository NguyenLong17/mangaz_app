import 'package:flutter/material.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/page/manga/bottom_navigation_bar_page.dart';
import 'package:manga_app/page/account/login_page.dart';
import 'package:manga_app/service/api_service.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(108.0),
          child: Image.asset('assets/images/main_image.png'),
        ),
      ),
    );
  }

  Future initData() async {

    await hive.init();

    final userJson = await hive.getValue(userKey);


    if (userJson != null) {
      final user = User.fromJson(userJson);
      apiService.user = user;

      navigatorPushAndRemoveUntil(context, const BottomNavigationBarPage());
    } else {
      navigatorPushAndRemoveUntil(context, const LoginPage());
    }
  }
}
