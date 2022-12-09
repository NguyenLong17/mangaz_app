import 'dart:async';
import 'package:manga_app/common/hive_manager.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/service/api_service.dart';

class MangaDetailBloc {
  static final _service = MangaDetailBloc._internal();

  factory MangaDetailBloc() => _service;

  MangaDetailBloc._internal();

  final _mangaDetailStreamController = StreamController<bool>.broadcast();

  Stream<bool> get mangaDetailStream => _mangaDetailStreamController.stream;

  final _mangaDetailFavoriteStreamController =
      StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaDetailFavoriteStream =>
      _mangaDetailFavoriteStreamController.stream;

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
    manga.favorite = !manga.favorite!;
    _mangaDetailStreamController.add(manga.favorite!);

    if (manga.favorite == false) {
      apiService.user?.mangafavorite?.remove(manga);
    } else {
      apiService.user?.mangafavorite?.add(manga);
    }

    hive.setValue(userKey, apiService.user);

    _mangaDetailFavoriteStreamController
        .add(apiService.user?.mangafavorite ?? []);
  }
}

final apiMangaDetailBloc = MangaDetailBloc();
