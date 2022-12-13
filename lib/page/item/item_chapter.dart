import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';
import 'package:manga_app/page/manga/read_chapter_manga_page.dart';

class ItemChapter extends StatefulWidget {
  final Manga manga;
  final Chapter chapter;
  final int indexChapter;

  const ItemChapter(
      {super.key,
      required this.chapter,
      required this.manga,
      required this.indexChapter});

  @override
  State<ItemChapter> createState() => _ItemChapterState();
}

class _ItemChapterState extends State<ItemChapter> {
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 200) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.grey,
              onPressed: _scrollToTop,
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.brown,
              ),
            ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.brown.shade500,
              floating: false,
              pinned: false,
              expandedHeight: 32,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigatorPushAndRemoveUntil(
                            context, MangaDetailPage(manga: widget.manga));
                      },
                      child: const Icon(
                        Icons.home_filled,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    if (widget.indexChapter > 0) ...[
                      GestureDetector(
                        onTap: () {
                          navigatorPushAndRemoveUntil(
                            context,
                            ItemChapter(
                              chapter: widget.manga
                                      .chapter?[widget.indexChapter - 1] ??
                                  Chapter(),
                              manga: widget.manga,
                              indexChapter: widget.indexChapter - 1,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.navigate_before_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      )
                    ],
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      widget.chapter.name ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (widget.indexChapter <
                        widget.manga.chapter!.length - 1) ...[
                      GestureDetector(
                        onTap: () {
                          navigatorPushAndRemoveUntil(
                            context,
                            ItemChapter(
                              chapter: widget.manga
                                      .chapter?[widget.indexChapter + 1] ??
                                  Chapter(),
                              manga: widget.manga,
                              indexChapter: widget.indexChapter + 1,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.navigate_next_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      )
                    ],
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        showListChapter();
                      },
                      child: const Icon(
                        Icons.list_alt,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          padding: const EdgeInsets.all(4),
          controller: _scrollController,
          itemBuilder: (context, index) {
            final image = widget.chapter.image?[index] ?? '';
            return CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            );
          },
          itemCount: widget.chapter.image?.length,
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 2), curve: Curves.linear);
  }

  void showListChapter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 256,
          child: ReadChapterMangaPage(manga: widget.manga, chapterSelect: widget.chapter),
        );
      }, // From with TextField inside
    );
  }
}
