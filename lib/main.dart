import 'package:flutter/material.dart';
import 'package:manga_app/page/page_demo/chat_page.dart';
import 'package:manga_app/page/splash_page.dart';

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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent, // hiển thị in đậm đằng sau
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      // home:  ChatPage(),
    );
  }
}
