import 'package:flutter/material.dart';
import 'package:manga_app/bloc/history_reading_bloc.dart';
import 'package:manga_app/bloc/manga_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/item/item_manga_story.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/manga_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MangaBloc mangaBloc;
  late HistoryReadingBloc historyReadingBloc;

  @override
  void initState() {
    mangaBloc = MangaBloc();
    historyReadingBloc = HistoryReadingBloc();
    apiMangaBloc.getMangas();
    apiMangaBloc.getMangaHot();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.brown.shade500,
              floating: true,
              pinned: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: RichText(
                  text: const TextSpan(
                    text: 'Manga',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Z',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: AutofillHints.streetAddressLine1,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                background: Image.asset(
                  'assets/images/dungeon_defense.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Truyện Hot mỗi ngày',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<List<Manga>>(
                stream: mangaBloc.mangaHotStream,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 256,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final mangaHot = mangaBloc.listMangaHot[index];

                        return GestureDetector(
                          onTap: () {
                            apiHistoryReadingBloc.addMangaHistory(mangaHot);
                            apiService.getMangaDetail(
                                idManga: mangaHot.id ?? '0');
                            navigatorPush(
                                context,
                                MangaDetailPage(
                                  manga: mangaHot,
                                ));
                          },
                          child: SizedBox(
                              width: 172,
                              child: Stack(
                                children: [
                                  ItemManga(manga: mangaHot),
                                  const Positioned(
                                    top: 0,
                                    right: 5,
                                    child: Icon(
                                      Icons.stars_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: 8,
                      ),
                      itemCount: mangaBloc.listMangaHot.length,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Colors.black12,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Lịch sử đọc truyện',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              buildMangaHistory(),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Colors.black12,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Danh sách truyện',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<List<Manga>>(
                stream: mangaBloc.mangaStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final mangas = snapshot.data ?? [];
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        final manga = mangas[index];
                        return GestureDetector(
                          onTap: () {
                            apiService.getMangaDetail(idManga: manga.id ?? '0');
                            apiHistoryReadingBloc.addMangaHistory(manga);

                            navigatorPush(
                                context,
                                MangaDetailPage(
                                  manga: manga,
                                ));
                          },
                          child: ItemManga(manga: manga),
                        );
                      },
                      itemCount: mangas.length,
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMangaHistory() {
    return StreamBuilder<List<Manga>>(
      stream: historyReadingBloc.historyReadingStream,
      builder: (context, snapshot) {
        final mangasHistory = apiHistoryReadingBloc.listMangaHistory;
        if (mangasHistory.isEmpty) {
          return const Center(
            child: Text('Hãy khám phá nhiều truyện hay hơn!'),
          );
        } else if (mangasHistory.isNotEmpty && mangasHistory.length < 6) {
          return SizedBox(
            height: 256,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final mangaHistory = mangasHistory[index];
                return GestureDetector(
                  onTap: () {
                    apiService.getMangaDetail(idManga: mangaHistory.id ?? '0');
                    navigatorPush(
                        context,
                        MangaDetailPage(
                          manga: mangaHistory,
                        ));
                  },
                  child: SizedBox(
                    width: 172,
                    child: ItemManga(manga: mangaHistory),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 8,
              ),
              itemCount: mangasHistory.length,
            ),
          );
        }
        return SizedBox(
          height: 256,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final mangaHistory = mangasHistory[index];
              return GestureDetector(
                onTap: () {
                  apiService.getMangaDetail(idManga: mangaHistory.id ?? '0');
                  navigatorPush(
                      context,
                      MangaDetailPage(
                        manga: mangaHistory,
                      ));
                },
                child: SizedBox(
                  width: 172,
                  child: ItemManga(manga: mangaHistory),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 8,
            ),
            itemCount: 5,
          ),
        );
      },
    );
  }
}
