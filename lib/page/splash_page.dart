import 'package:flutter/material.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/page/bottom_navigation_bar_page.dart';
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
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }

  Future initData() async {
    // await sharedPrefs.init();
    // await secureStorage.init();

    await hive.init();

    final userJson = await hive.getValue(userKey);

    // final mangaFavoriteJson = await hive.getValue(mangaFavoriteKey);
    // final manga = List<Manga>.from(mangaFavoriteJson.map((e) => Manga.fromJson(e)));
    // apiService.mangaFavorite = manga;

    // mangaFavorite

    if (userJson != null) {
      final user = User.fromJson(userJson);
      // apiService.token = user.token ?? '';

      apiService.user = user;


      navigatorPushAndRemoveUntil(context, const BottomNavigationBarPage());
    } else {
      navigatorPushAndRemoveUntil(context, const LoginPage());
    }
  }
}
