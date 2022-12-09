import 'package:flutter/material.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/item/item_chapter.dart';

class ReadChapterMangaPage extends StatefulWidget {
  final Manga manga;

  const ReadChapterMangaPage({super.key, required this.manga});

  @override
  State<ReadChapterMangaPage> createState() => _ReadChapterMangaPageState();
}

class _ReadChapterMangaPageState extends State<ReadChapterMangaPage> {
  bool showBackToTopButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            showBackToTopButton = true;
          } else {
            showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: widget.manga.chapter?.length ?? 0,
                  (context, index) {
                final chapter = widget.manga.chapter?[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigatorPush(context,
                            ItemChapter(chapter: chapter ?? Chapter()));
                      },
                      child: buildChapterManga(chapter ?? Chapter()),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChapterManga(Chapter chapter) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade700,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        chapter.name ?? '',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
