import 'dart:async';
import 'package:manga_app/model/categories.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/categories_service.dart';

class CategoriesBloc {

  static final _service = CategoriesBloc._internal();

  factory CategoriesBloc() => _service;

  CategoriesBloc._internal();

  final _categoriesStreamController = StreamController<List<Categories>>.broadcast();

  Stream<List<Categories>> get categoriesStream => _categoriesStreamController.stream;

  final _showCategoriesStreamController = StreamController<bool>.broadcast();

  Stream<bool> get showCategoriesStream =>
      _showCategoriesStreamController.stream;


  bool showCategories = true;

  final List<Categories> categories = [];

  //
  // CategoriesBloc() {
  //   getCategories();
  // }


  Future<void> getCategories() async {
    await Future.delayed(const Duration(seconds: 2));
    await apiService.getCategories().then((value) {
      if (value.isNotEmpty) {
        categories.clear();
        categories.addAll(value);
        _categoriesStreamController.add(categories);
      }
    }).catchError((e) {
      _categoriesStreamController.addError(e.toString());
    });
  }

  Future<void> checkShowCategories(String keyword) async {
    if (keyword.isEmpty) {
      showCategories = true;
      _showCategoriesStreamController.add(showCategories);
    } else {
      showCategories = false;
      _showCategoriesStreamController.add(showCategories);
    }
  }
}

final apiCategoriesBloc = CategoriesBloc();
