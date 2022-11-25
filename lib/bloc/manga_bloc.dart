import 'dart:async';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:manga_app/common/widgets/progress_dialog.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/manga_service.dart';

class MangaBloc {
  final _mangasStreamController = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaStream => _mangasStreamController.stream;

  final _mangaHotStreamController = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get mangaHotStream => _mangaHotStreamController.stream;

  final List<Manga> mangas = [];

  final listFilter = <Manga>[];

   List<Manga> listMangaHot = [];

  MangaBloc() {
    getMangas();
    getMangaHot();
  }

  Future<void> getMangas() async {
    // final progressDialog = ProgressDialog(context);

    // progressDialog.show();

    await Future.delayed(const Duration(seconds: 1));
    await apiService.getMangas().then((value) {
      if (value.isNotEmpty) {
        mangas.addAll(value);
        _mangasStreamController.add(mangas);
      }
      // progressDialog.hide();
    }).catchError((e) {
      // progressDialog.hide();
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
    listFilter.clear();

    listFilter.addAll(mangas
        .where((element) =>
            element.name?.toLowerCase().contains(keyword.toLowerCase()) == true)
        .toList());

    _mangasStreamController.add(listFilter);
  }
}
