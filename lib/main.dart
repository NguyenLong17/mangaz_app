import 'package:flutter/material.dart';
import 'package:manga_app/page/bottom_navigation_bar_page.dart';
import 'package:manga_app/page/categories/categories_page.dart';
import 'package:manga_app/page/manga/home_page.dart';
import 'package:manga_app/page/item/item_manga_story.dart';
import 'package:manga_app/page/splash_page.dart';
import 'package:manga_app/page/page_demo/tabbar.dart';
import 'package:manga_app/page/account/profile_page.dart';
import 'package:manga_app/page/manga/read_chapter_manga_page.dart';
import 'package:manga_app/page/item/item_chapter.dart';
import 'package:manga_app/page/account/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home:  RegisterPage(),
      // home:  LoginPage(),
      home:  SplashPage(),
      // home:  BottomNavigationBarPage(),
      // home:  ItemMangaDetailPage(),
      // home:  CategoriesPage(),
      // home:  ProfilePage(),
      // home:  ReadMangaPage(),
      // home:  HomePage(),
      // home:  TabBarPage(),
      // home:  ItemChapter(),


    );
  }
}
