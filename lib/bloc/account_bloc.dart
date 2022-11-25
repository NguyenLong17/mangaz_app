import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manga_app/common/widgets/progress_dialog.dart';
import 'package:manga_app/common/widgets/toast_overlay.dart';
import 'package:manga_app/model/manga.dart';
import 'package:manga_app/model/user.dart';
import 'package:manga_app/service/api_service.dart';
import 'package:manga_app/service/manga_service.dart';
import 'package:manga_app/service/user_service.dart';

class AccountBloc {
  final _userStreamController = StreamController<User>.broadcast();

  Stream<User> get userStream => _userStreamController.stream;

  // User? user;

  // final List<Manga> mangas = [];

  List<Manga> listMangaHot = [];

  AccountBloc() {
    getProfile();
    print('AccountBloc.AccountBloc');
  }

  Future<void> getProfile() async {
    // await Future.delayed(const Duration(seconds: 1));
    await apiService
        .getProfile(
      id: int.parse(apiService.user?.id ?? '0'),
    )
        .then((value) {
      apiService.user = value;
      // print('AccountBloc.getProfile: ${user?.name}');
      _userStreamController.add(apiService.user ?? User());
    }).catchError((e) {
      // progressDialog.hide();
      _userStreamController.addError(e.toString());
    });
  }

  Future<void> updateProfile({
    required String name,
    required String dateOfBirth,
    required String email,
  }) async {
    apiService
        .updateProfile(
      id: int.parse(apiService.user?.id ?? '0'),
      name: name,
      dateOfBirth: dateOfBirth,
      email: email,
      // avatar: url,
    )
        .then((profileUser) {
      profileUser.name = name;
      profileUser.dateOfBirth = dateOfBirth;
      profileUser.email = email;
      // profileUser.avatar = apiService.user?.avatar;

      // ToastOverlay(context).showToastOverlay(
      //     message: 'Cập nhật thành công', type: ToastType.success);

      // navigatorPushAndRemoveUntil(context, BottomNavigationBarPage());
      _userStreamController.add(profileUser);
    }).catchError((e) {
      print('AccountBloc.updateProfile: ${e.toString()}');
      // ToastOverlay(context).showToastOverlay(
      //     message: 'Có lỗi xảy ra: ${e.toString()}', type: ToastType.error);
    });
  }
}
