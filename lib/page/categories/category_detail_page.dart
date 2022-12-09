import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/bloc/history_reading_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/model/categories.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/manga_service.dart';


class CategoryDetailPage extends StatefulWidget {
  final Categories categories;

  const CategoryDetailPage({super.key, required this.categories});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          buildAppBar(context: context, title: widget.categories.name ?? ''),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    List<Manga>? mangas = widget.categories.manga;

    if (mangas?.length != 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Miêu tả',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(widget.categories.content ?? ''),
            const SizedBox(
              height: 16,
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                var manga = mangas?[index];

                return GestureDetector(
                  onTap: () {
                    apiService.getMangaDetail(idManga: manga?.id ?? '');
                    apiHistoryReadingBloc.addMangaHistory(manga ?? Manga());

                    navigatorPush(context, MangaDetailPage(manga: manga ?? Manga()));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: manga?.avatar ?? '',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            manga?.name ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: mangas?.length ?? 0,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Miêu tả',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(widget.categories.content ?? ''),
            const SizedBox(
              height: 56,
            ),
            const Text('Danh sách truyện đang được cập nhật!'),
          ],
        ),
      );
    }
  }
}
