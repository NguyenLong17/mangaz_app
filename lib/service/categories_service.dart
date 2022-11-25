import 'package:manga_app/model/categories.dart';
import 'package:manga_app/service/api_service.dart';


extension CategoriesService on APIService {

  Future<List<Categories>> getCategories() async {
    final result = await request(
      path: '/categories',
      method: Method.get,
    );

    final categories = List<Categories>.from(result.map((e) => Categories.fromJson(e)));
    return categories;
  }

  Future<Categories> getCategoriesDetail({required int idCategories}) async {
    final result = await request(
      path: '/categories/$idCategories',
      method: Method.get,
    );

    final category = Categories.fromJson(result);
    print('leng api manga: ${category.manga!.length}');
    return category;
  }

}
