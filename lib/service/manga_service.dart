import 'package:manga_app/model/manga.dart';
import 'package:manga_app/service/api_service.dart';


extension MangaService on APIService {
  Future<List<Manga>> getMangas() async {
    final result = await request(
      path: '/manga',
      method: Method.get,
    );

    final mangas = List<Manga>.from(result.map((e) => Manga.fromJson(e)));
    return mangas;
  }

  Future<Manga> getMangaDetail({required String idManga}) async {
    final result = await request(
      path: '/manga/$idManga',
      method: Method.get,
    );

    final manga = Manga.fromJson(result);
    return manga;
  }

}
