import 'package:flutter/material.dart';
import 'package:manga_app/bloc/categories_bloc.dart';
import 'package:manga_app/bloc/history_reading_bloc.dart';
import 'package:manga_app/bloc/manga_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/common/widgets/mytextfield.dart';
import 'package:manga_app/model/categories.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/page/categories/category_detail_page.dart';
import 'package:manga_app/page/item/item_manga_story.dart';
import 'package:manga_app/page/manga/manga_detail_page.dart';

class SearchPage extends StatefulWidget {
   SearchPage({Key? key}) : super(key: key);

  // @override
  // State<SearchPage> createState() => _SearchPageState();

  // tạo trạng thái
  _SearchPageState? state;

  @override
  State<SearchPage> createState() => state ??= _SearchPageState();

  //nếu state = null => gọi hàm reload() => gọi hàm reload.searchManga()
  reload() => state?.reload();
}

class _SearchPageState extends State<SearchPage> {
  late MangaBloc mangaBloc;
  final keywordController = TextEditingController();
  late CategoriesBloc categoriesBloc;

  void reload(){
    mangaBloc.searchMangas('');
  }

  @override
  void initState() {
    mangaBloc = MangaBloc();
    categoriesBloc = CategoriesBloc();
    apiCategoriesBloc.getCategories();
    // Future.delayed(Duration(seconds: 2), () {
    //   mangaBloc.searchMangas('');
    // });


    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: 'Tìm kiếm',
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(

      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MyTextField(
            controller: keywordController,
            hintText: 'Nhập tên truyện',
            onChanged: mangaBloc.searchMangas,
          ),
          const SizedBox(
            height: 16,
          ),
          StreamBuilder<bool>(
              stream: categoriesBloc.showCategoriesStream,
              builder: (context, snapshot) {
                return Container(
                  child: categoriesBloc.showCategories
                      ? buildCategories()
                      : Container(),
                );
              }),
          const SizedBox(
            height: 16,
          ),
          StreamBuilder<List<Manga>>(
            // stream: mangaBloc.mangaStream,
            stream: mangaBloc.mangaFilterStream,
            builder: (context, snapshot) {
              final mangas = snapshot.data ?? [];
              // final mangas = snapshot.data ?? [];
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final manga = mangas[index];
                  return GestureDetector(
                    onTap: () {
                      apiHistoryReadingBloc.addMangaHistory(manga);
                      navigatorPush(context, MangaDetailPage(manga: manga));
                    },
                    child: ItemManga(manga: manga),
                  );
                },
                itemCount: mangas.length,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return StreamBuilder<List<Categories>>(
      stream: categoriesBloc.categoriesStream,
      builder: (context, snapshot) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          clipBehavior: Clip.antiAlias,
          children: [
            for (var category in apiCategoriesBloc.categories)
              GestureDetector(
                onTap: () {
                  navigatorPush(
                      context, CategoryDetailPage(categories: category));
                },
                child: IntrinsicWidth(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade200,
                    ),
                    child: Text(category.name ?? ''),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
