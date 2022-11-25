import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/bloc/categories_bloc.dart';
import 'package:manga_app/common/util/navigator.dart';
import 'package:manga_app/common/widgets/appbar.dart';
import 'package:manga_app/model/categories.dart';
import 'package:manga_app/page/categories/category_detail_page.dart';
import 'package:manga_app/page/item/item_manga_story.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/categories_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late CategoriesBloc categoriesBloc;

  @override
  void initState() {
    categoriesBloc = CategoriesBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: 'Thể loại'),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<Categories>>(
      stream: categoriesBloc.categoriesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData) {
          final categories = snapshot.data ?? [];
          return GridView.builder(
            padding: EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 4.5,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              // final manga = category.manga?[index];
              return GestureDetector(
                onTap: () {
                  navigatorPush(context, CategoryDetailPage(categories: category));
                  // categoriesBloc.categoriesSelected = category;
                  // categoriesBloc.getMangaCategory(idCategories: int.parse(category.id ?? ''));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade200,
                  ),
                  child: Text(category.name ?? ''),
                ),
              );
            },
            itemCount: categories.length,
          );
        }
        return Container();
      },
    );
  }

  // Widget buildListManga(Categories categories) {
  //   final mangas = categories.manga;
  //
  //
  //   if (categoriesBloc.categoriesSelected == null) {
  //     categoriesBloc.categoriesSelected = categories;
  //     categoriesBloc.getMangaCategory(idCategories: int.parse(categories.id ?? ''));
  //   }
  //
  //   return Column(
  //     children: [
  //       Text(categories.content ?? ''),
  //       Container(
  //         height: 300,
  //         child: GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 4,
  //             crossAxisSpacing: 4,
  //             // childAspectRatio: 4.5,
  //           ),
  //           itemBuilder: (context, index) {
  //             final manga = mangas?[index];
  //             return Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     flex: 5,
  //                     child: Container(
  //                       width: double.infinity,
  //                       child: CachedNetworkImage(
  //                         imageUrl: manga?.avatar ?? '',
  //                         placeholder: (context, url) =>
  //                             const CircularProgressIndicator(),
  //                         errorWidget: (context, url, error) =>
  //                             const Icon(Icons.error),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 4,
  //                   ),
  //                   Expanded(
  //                     flex: 1,
  //                     child: Text(
  //                       manga?.name ?? '',
  //                       style: const TextStyle(
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //           itemCount: mangas?.length ?? 0,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
