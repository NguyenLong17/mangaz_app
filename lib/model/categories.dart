import 'package:manga_app/model/manga.dart';

class Categories {
  Categories({
    this.name,
    this.content,
    this.manga,
    this.id,
  });

  Categories.fromJson(dynamic json) {
    name = json['name'];
    content = json['content'];
    if (json['manga'] != null) {
      manga = [];
      json['manga'].forEach((v) {
        manga?.add(Manga.fromJson(v));
      });
    }
    id = json['id'];
  }

  String? name;
  String? content;
  List<Manga>? manga;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['content'] = content;
    if (manga != null) {
      map['manga'] = manga?.map((v) => v.toJson()).toList();
    }
    map['id'] = id;
    return map;
  }
}

// class MangaCategory {
//   MangaCategory({
//       this.name,
//       this.avatar,
//       this.author,
//       this.anotherName,
//       this.view,
//       this.content,
//       this.category,
//       this.chapter,
//       this.id,});
//
//   MangaCategory.fromJson(dynamic json) {
//     name = json['name'];
//     avatar = json['avatar'];
//     author = json['author'];
//     anotherName = json['anotherName'];
//     view = json['view'];
//     content = json['content'];
//     if (json['category'] != null) {
//       category = [];
//       json['category'].forEach((v) {
//         category?.add(Category.fromJson(v));
//       });
//     }
//     if (json['chapter'] != null) {
//       chapter = [];
//       json['chapter'].forEach((v) {
//         chapter?.add(Chapter.fromJson(v));
//       });
//     }
//     id = json['id'];
//   }
//   String? name;
//   String? avatar;
//   String? author;
//   String? anotherName;
//   int? view;
//   String? content;
//   List<Category>? category;
//   List<Chapter>? chapter;
//   String? id;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['name'] = name;
//     map['avatar'] = avatar;
//     map['author'] = author;
//     map['anotherName'] = anotherName;
//     map['view'] = view;
//     map['content'] = content;
//     if (category != null) {
//       map['category'] = category?.map((v) => v.toJson()).toList();
//     }
//     if (chapter != null) {
//       map['chapter'] = chapter?.map((v) => v.toJson()).toList();
//     }
//     map['id'] = id;
//     return map;
//   }
//
// }
//
// class Chapter {
//   Chapter({
//       this.name,
//       this.image,});
//
//   Chapter.fromJson(dynamic json) {
//     name = json['name'];
//     image = json['image'] != null ? json['image'].cast<String>() : [];
//   }
//   String? name;
//   List<String>? image;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['name'] = name;
//     map['image'] = image;
//     return map;
//   }
//
// }
//
// class Category {
//   Category({
//       this.id,
//       this.name,
//       this.description,});
//
//   Category.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//   }
//   String? id;
//   String? name;
//   String? description;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['description'] = description;
//     return map;
//   }
//
// }
