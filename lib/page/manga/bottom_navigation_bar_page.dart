import 'package:flutter/material.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/page/manga/home_page.dart';
import 'package:manga_app/page/account/profile_page.dart';
import 'package:manga_app/page/search_page.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final pages = <Widget>[];
  late TabController controller;

  SearchPage searchPage = SearchPage();

  @override
  void initState() {
    createListPage();
    hive.getValue(userKey);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    final items = getItems();
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          controller.animateTo(index);
        });
      },
      selectedLabelStyle: const TextStyle(color: Colors.black),
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Trang chủ',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Tìm kiếm',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.co_present_sharp),
        label: 'Tài khoản',
      ),
    ];
  }

  void createListPage() {
    pages.addAll([
      const HomePage(),
      searchPage,
      const ProfilePage(),
    ]);

    controller = TabController(
        initialIndex: currentIndex, length: pages.length, vsync: this);
    controller.addListener(onChanged);
  }

  void onChanged() {
    setState(() {
      currentIndex = controller.index;
      if (currentIndex == 1){
        searchPage.reload();
      }
    });
  }
}
