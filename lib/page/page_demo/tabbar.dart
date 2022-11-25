import 'package:flutter/material.dart';

import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/tabbar.dart';
import 'package:manga_app/page/account/login_page.dart';
import 'package:manga_app/page/account/register_page.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final items = <Widget>[];
  final pages = <Widget>[];

  @override
  void initState() {
    items.addAll([
      Text('Home 1'),
      Text('Home 2'),
      Text('Home 3'),
      Text('Home 4'),
      Text('Home 5'),
    ]);

    pages.addAll([
      Container(color: Colors.yellow),
      Container(color: Colors.red),
      Container(color: Colors.blueAccent),
      LoginPage(),
      RegisterPage()
    ]);

    controller = TabController(length: items.length, vsync: this);
    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: 'Tabbar demo'),
      body: SafeArea(
        child: Column(
          children: [
            buildTabbar(),
            Expanded(
              child: buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabbar() {
    return Container(
      height: 40,
      child: TabBar(
        controller: controller,
        tabs: items,
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.red,
        isScrollable: true,
        indicatorColor: Colors.red,
      ),
    );
  }

  Widget buildBody() {
    return TabBarStack(
      index: controller.index,
      children: pages,
      duration: Duration(milliseconds: 150),
      previous: () {
        final currentIndex = controller.index;
        int newIndex = currentIndex - 1;
        if (newIndex < 0) {
          newIndex = 0;
        }
        controller.animateTo(newIndex);
      },
      next: () {
        final currentIndex = controller.index;
        int newIndex = currentIndex + 1;
        if (newIndex >= items.length) {
          newIndex = items.length - 1;
        }
        controller.animateTo(newIndex);
      },
    );
  }
}
