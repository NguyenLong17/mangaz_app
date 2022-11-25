import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/model/manga.dart';

class ItemChapter extends StatefulWidget {
  final Chapter chapter;

  const ItemChapter({super.key, required this.chapter});

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
    print('_ItemChapterState.initState');
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
                backgroundColor: Colors.brown.shade500,
                floating: false,
                pinned: false,
                expandedHeight: 32,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.chapter.name ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView.builder(
            padding: EdgeInsets.all(4),
            controller: _scrollController,
            itemBuilder: (context, index) {
              final image = widget.chapter.image?[index] ?? '';
              return CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              );
            },
            itemCount: widget.chapter.image?.length,
          ),
        ));
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 2), curve: Curves.linear);
  }
}
