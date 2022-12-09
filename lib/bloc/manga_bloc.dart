import 'dart:async';
import 'package:manga_app/bloc/categories_bloc.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/manga_service.dart';

class MangaBloc {
  static final _service = MangaBloc._internal();

  factory MangaBloc() => _service;

  MangaBloc._internal();

  final _mangasStreamController = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaStream => _mangasStreamController.stream;

  final _mangaHotStreamController = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaHotStream => _mangaHotStreamController.stream;

  final _mangaFilterStreamController =
      StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaFilterStream =>
      _mangaFilterStreamController.stream;

  final List<Manga> mangas = [];

  var listFilter = <Manga>[];

  List<Manga> listMangaHot = [];

  // MangaBloc() {
  //   getMangas();
  //   getMangaHot();
  // }

  Future<void> getMangas() async {
    await apiService.getMangas().then((value) {
      if (value.isNotEmpty) {
        mangas.addAll(value);
        mangas.shuffle();

        _mangasStreamController.add(mangas);
      }
    }).catchError((e) {
      _mangasStreamController.addError(e.toString());
    });
  }

  Future<void> getMangaHot() async {
    await Future.delayed(const Duration(seconds: 1));
    await apiService.getMangas().then((value) {
      if (value.isNotEmpty) {
        List<Manga> listManga = [];
        listManga.addAll(value);
        listMangaHot.clear();
        listManga.sort((a, b) => (b.view ?? 0).compareTo((a.view ?? 1)));
        listMangaHot = listManga.take(5).toList();
        _mangaHotStreamController.add(listMangaHot);
      }
    }).catchError((e) {
      _mangaHotStreamController.addError(e.toString());
    });
  }

  Future<void> searchMangas(String keyword) async {
    // mangas.shuffle();

    if (keyword.isNotEmpty) {
      listFilter.clear();

      CategoriesBloc().checkShowCategories(keyword);

      listFilter.addAll(mangas
          .where((element) =>
              element.name?.toLowerCase().contains(keyword.toLowerCase()) ==
              true)
          .toList());
      _mangaFilterStreamController.add(listFilter);
    } else {
      CategoriesBloc().checkShowCategories(keyword);
      listFilter.addAll(mangas);
      _mangaFilterStreamController.add(listFilter);
    }
  }


}

final apiMangaBloc = MangaBloc();
