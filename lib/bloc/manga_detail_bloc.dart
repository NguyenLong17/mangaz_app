import 'dart:async';
import 'dart:convert';

import 'package:manga_app/model/manga.dart';
import 'package:manga_app/service/api_service.dart';

class MangaDetailBloc {

  static final _service = MangaDetailBloc._internal();

  factory MangaDetailBloc() => _service;


  MangaDetailBloc._internal();

  final _mangaDetailStreamController = StreamController<bool>.broadcast();

  Stream<bool> get mangaDetailStream => _mangaDetailStreamController.stream;

  final _mangaDetailFavoriteStreamController = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaDetailFavoriteStream => _mangaDetailFavoriteStreamController.stream;

  bool isFavorite = false;
  bool showContent = false;
  bool iconShow = false;

  // List<Manga> listMangaF = [];

  void checkFavorite() {
    isFavorite = !isFavorite;
    _mangaDetailStreamController.add(isFavorite);
  }

  void checkContent() {
    showContent = !showContent;
    iconShow = !iconShow;
    _mangaDetailStreamController.add(iconShow);
    _mangaDetailStreamController.add(showContent);
  }

  void addMangaFavorite(Manga manga) {

    apiService.user?.mangafavorite?.add(manga);

    print('manga bloc: ${apiService.user?.mangafavorite?.length}');
    _mangaDetailFavoriteStreamController.add(apiService.user?.mangafavorite ?? [] );


    // String dataString = jsonEncode(manga);
    // mangaFavorite.add(dataString);
    // hive.setValue(mangaFavoriteKey, mangaFavorite);

    // print('Manga Favorite: ${apiService.mangaFavorite.length} ');
  }

}

final apiMangaDetailBloc = MangaDetailBloc();

