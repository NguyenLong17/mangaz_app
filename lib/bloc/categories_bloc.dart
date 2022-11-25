import 'dart:async';
import 'package:manga_app/model/categories.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/categories_service.dart';

class CategoriesBloc {

  final _categoriesStreamController = StreamController<List<Categories>>();

  Stream<List<Categories>> get categoriesStream => _categoriesStreamController.stream;

  //
  // final _categoryStreamController = StreamController<List<Mamga>>();
  //
  // Stream<List<MangaCategory>> get categoryStream => _categoryStreamController.stream;

  final List<Categories> categories = [];

  // Categories? categoriesSelected;
  // final listFilter = <Manga>[];

  CategoriesBloc() {
    getCategories();
  }

  // void dispose(){
  //   _categoryStreamController.close();
  // }


  Future<void> getCategories() async {
    // final progressDialog = ProgressDialog(context);

    // progressDialog.show();

    await Future.delayed(const Duration(seconds: 2));
    await apiService.getCategories().then((value) {
      if (value.isNotEmpty) {
        categories.addAll(value);
        _categoriesStreamController.add(categories);
      }
      // progressDialog.hide();
    }).catchError((e) {
      // progressDialog.hide();
      _categoriesStreamController.addError(e.toString());
    });
  }

  // Future getMangaCategory({required int idCategories}) async {
  //
  //   apiService.getCategoriesDetail(idCategories: idCategories).then((category) {
  //     var mangas = category.manga;
  //     listFilter.clear();
  //     listFilter.addAll(mangas ?? []);
  //     _categoryStreamController.add(listFilter);
  //
  //     print('Data api: ${listFilter.length}');
  //   }).catchError((e) {
  //     print('CategoriesBloc.getMangaCategory: ${e.toString()}');
  //   });
  //
  // }


}
