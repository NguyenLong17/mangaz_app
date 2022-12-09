import 'dart:async';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/user.dart';


class HistoryReadingBloc {
  static final _service = HistoryReadingBloc._internal();

  factory HistoryReadingBloc() => _service;

  HistoryReadingBloc._internal();

  final listMangaHistoryReading = StreamController<List<Manga>>.broadcast();

  Stream<List<Manga>> get historyReadingStream => listMangaHistoryReading.stream;


  List<Manga> listMangaHistory = [];
  List<Manga> listMangaHistoryRead = [];

  Future<void> addMangaHistory(Manga manga)  async {
    listMangaHistory.insert(0, manga);
    listMangaHistoryReading.add(listMangaHistory);
  }




}

final apiHistoryReadingBloc = HistoryReadingBloc();
