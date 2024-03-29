import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/bloc/manga_detail_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/mybutton.dart';
import 'package:manga_app/common/widgets/tabbar.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/item/item_chapter.dart';
import 'package:manga_app/page/manga/bottom_navigation_bar_page.dart';
import 'package:manga_app/page/manga/read_chapter_manga_page.dart';

class MangaDetailPage extends StatefulWidget {
  final Manga manga;

  const MangaDetailPage({super.key, required this.manga});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage>
    with SingleTickerProviderStateMixin {
  late MangaDetailBloc mangaDetailBloc;

  late TabController controller;
  final items = <Widget>[];
  final pages = <Widget>[];
  Color? color;

  final mangaFavorite = <String>[];

  @override
  void initState() {
    mangaDetailBloc = MangaDetailBloc();
    createTabBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.brown.shade500,
              floating: false,
              pinned: true,
              centerTitle: true,
              // primary: false,
              expandedHeight: 200,
              actions: [
                GestureDetector(
                  onTap: () {
                    navigatorPushAndRemoveUntil(
                        context, const BottomNavigationBarPage());
                  },
                  child: const Icon(
                    Icons.home_filled,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 4,
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          widget.manga.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  background: CachedNetworkImage(
                    imageUrl: widget.manga.avatar ?? '',
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 72,
              // height: 40,
              child: TabBar(
                controller: controller,
                tabs: items,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.red,
                isScrollable: true,
                indicatorColor: Colors.red,
              ),
            ),
            Expanded(child: buildBodyPage()),
          ],
        ),
      ),
    );
  }

  Widget buildMangaDetail() {
    return StreamBuilder<bool>(
        stream: mangaDetailBloc.mangaDetailStream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              controller: ScrollController(),
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Tác giả: ${widget.manga.author}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          mangaDetailBloc.addMangaFavorite(widget.manga);
                          ToastOverlay(context).showToastOverlay(
                              message: 'Theo dõi thành công',
                              type: ToastType.success);
                        },
                        child: widget.manga.favorite ?? false
                            ? const Icon(
                                Icons.favorite_outlined,
                                size: 58,
                                color: Colors.pink,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                size: 58,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Nội dung:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.manga.content ?? '',
                  maxLines: mangaDetailBloc.showContent ? 10 : 2,
                ),
                Center(
                  child: IconButton(
                    onPressed: () {
                      mangaDetailBloc.checkContent();
                    },
                    icon: mangaDetailBloc.iconShow
                        ? const Icon(Icons.keyboard_arrow_up_outlined)
                        : const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Lượt xem: ${widget.manga.view}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Thể loại:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.manga.tag?.length ?? 0,
                    itemBuilder: (context, index) {
                      final tag = widget.manga.tag?[index];
                      return buildTitleManga(tag ?? Tag());
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                MyButton(
                  textButton: 'Đọc truyện',
                  backgroundColor: Colors.red,
                  onTap: () {
                    navigatorPush(
                      context,
                      ItemChapter(
                        indexChapter: 0,
                        chapter: widget.manga.chapter?[0] ?? Chapter(),
                        manga: widget.manga,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget buildTitleManga(Tag tag) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(tag.name ?? ''),
      ),
    );
  }

  Widget buildBodyPage() {
    return TabBarStack(
      index: controller.index,
      duration: const Duration(milliseconds: 150),
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
      children: pages,
    );
  }

  void createTabBar() {
    items.addAll([
      Container(
        alignment: Alignment.center,
        height: 56,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade500),
            color: Colors.grey.shade200),
        child: const Text(
          'Nội dung',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 56,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade500),
            color: Colors.grey.shade200),
        child: const Text(
          'Chapter',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
    pages.addAll([
      buildMangaDetail(),
      ReadChapterMangaPage(manga: widget.manga),
    ]);

    controller = TabController(length: items.length, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }
}
