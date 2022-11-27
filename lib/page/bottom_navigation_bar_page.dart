import 'package:flutter/material.dart';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/page/categories/categories_page.dart';
import 'package:manga_app/page/manga/home_page.dart';
import 'package:manga_app/page/account/profile_page.dart';
import 'package:manga_app/page/search_page.dart';
import 'package:manga_app/service/api_service.dart';

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
          print('Index Page = $index');
        });
      },
      selectedLabelStyle: const TextStyle(color: Colors.black),
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      elevation: 0,
    );
  }

  List<BottomNavigationBarItem> getItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Category',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.propane,
        ),
        label: 'Story',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.co_present_sharp),
        label: 'Account',
      ),
    ];
  }

  void createListPage() {
    pages.addAll([
      HomePage(),
      CategoriesPage(),
      SearchPage(),
      Container(color: Colors.purple),
      ProfilePage(),
    ]);

    controller = TabController(
        initialIndex: currentIndex, length: pages.length, vsync: this);
    controller.addListener(onChanged);
  }

  void onChanged() {
    setState(() {
      currentIndex = controller.index;
    });
  }
}
