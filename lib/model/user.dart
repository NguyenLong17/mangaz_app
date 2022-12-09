import 'package:manga_app/model/manga.dart';

class User {
  User({
    this.name,
    this.phoneNumber,
    this.email,
    this.password,
    this.passwordConfirm,
    this.dateOfBirth,
    this.avatar,
    this.mangafavorite,
    this.coin,
    this.point,
    this.id,
  });

  User.fromJson(dynamic json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    passwordConfirm = json['passwordConfirm'];
    dateOfBirth = json['dateOfBirth'];
    avatar = json['avatar'];
    if (json['mangafavorite'] != null) {
      mangafavorite = [];
      json['mangafavorite'].forEach((v) {
        mangafavorite?.add(Manga.fromJson(v));
      });
    }
    coin = json['coin'];
    point = json['point'];
    id = json['id'];
  }

  String? name;
  String? phoneNumber;
  String? email;
  String? password;
  String? passwordConfirm;
  String? dateOfBirth;
  String? avatar;
  List<Manga>? mangafavorite;
  int? coin;
  int? point;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['email'] = email;
    map['password'] = password;
    map['passwordConfirm'] = passwordConfirm;
    map['dateOfBirth'] = dateOfBirth;
    map['avatar'] = avatar;
    if (mangafavorite != null) {
      map['mangafavorite'] = mangafavorite?.map((v) => v.toJson()).toList();
    }
    map['coin'] = coin;
    map['point'] = point;
    map['id'] = id;
    return map;
  }
}
