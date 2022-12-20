import 'dart:async';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/user_service.dart';

class AccountBloc {
  static final _service = AccountBloc._internal();

  factory AccountBloc() => _service;

  AccountBloc._internal();

  final _userStreamController = StreamController<User>.broadcast();

  Stream<User> get userStream => _userStreamController.stream;


  List<Manga> listMangaHot = [];

  Future<void> getProfile() async {

    // await Future.delayed(const Duration(seconds: 3));
    await apiService
        .getProfile(
      id: int.parse(apiService.user?.id ?? '0'),
    )
        .then((value) {
      apiService.user = value;
      _userStreamController.add(apiService.user ?? User());
    }).catchError(
      (e) {
        _userStreamController.addError(e.toString());
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String dateOfBirth,
    required String email,
    required String avatar
  }) async {
    apiService
        .updateProfile(
      id: int.parse(apiService.user?.id ?? '0'),
      name: name,
      dateOfBirth: dateOfBirth,
      email: email,
      avatar: avatar,
    )
        .then((profileUser) {
      profileUser.name = name;
      profileUser.dateOfBirth = dateOfBirth;
      profileUser.email = email;
      _userStreamController.add(profileUser);
    }).catchError((e) {});
  }
}

final apiAccountBloc = AccountBloc();
