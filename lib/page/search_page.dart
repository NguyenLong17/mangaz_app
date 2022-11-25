import 'package:flutter/material.dart';
import 'package:manga_app/bloc/manga_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/item/item_manga_story.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MangaBloc mangaBloc;
  final keywordController = TextEditingController();

  @override
  void initState() {
    mangaBloc = MangaBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: 'Tìm kiếm'),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<Manga>>(
      stream: mangaBloc.mangaStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final mangas = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                MyTextField(
                  controller: keywordController,
                  hintText: 'Nhập tên truyện',
                  onChanged: mangaBloc.searchMangas,
                ),
                SizedBox(
                  height: 16,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final manga = mangas[index];

                    return GestureDetector(
                      onTap: () {
                        navigatorPush(context, MangaDetailPage(manga: manga));
                      },
                      child: ItemManga(manga: manga),
                    );
                  },
                  itemCount: mangas.length,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
