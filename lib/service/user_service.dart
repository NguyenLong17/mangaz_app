import 'package:manga_app/model/user.dart';
import 'package:manga_app/service/api_service.dart';

extension UserService on APIService {
  Future<User> login({
    required String phoneNumber,
    required String password,
  }) async {
    final body = {
      "phoneNumber": phoneNumber,
      "password": password,
    };

    final result = await request(
      path: '/user',
      body: body,
      method: Method.post,
    );

    final user = User.fromJson(result);
    return user;
  }

  Future<User> register({
    required String phoneNumber,
    required String password,
    String? passwordConfirm,
    String? name,
    String? email,
    String? dateOfBirth,
  }) async {
    final body = {
      "phoneNumber": phoneNumber,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
      "email": email,
      "dateOfBirth": dateOfBirth,
    };

    final result = await request(
      path: '/user',
      body: body,
      method: Method.post,
    );

    final user = User.fromJson(result);
    return user;
  }

  Future<User> getProfile({required int id}) async {
   // await Future.delayed(const Duration(seconds: 1));
    final result = await request(
      path: '/user/$id',
      method: Method.get,
    );
    final profileUser = User.fromJson(result);

    return profileUser;
  }

  Future<User> updateProfile(
      {required int id,
      required String name,
      required String dateOfBirth,
      required String email,
      required String avatar}) async {
    final body = {
      "name": name,
      "dateOfBirth": dateOfBirth,
      "email": email,
      "avatar": avatar,
    };
    final result = await request(
      path: '/user/$id',
      body: body,
      method: Method.put,
    );
    final profileUser = User.fromJson(result);

    return profileUser;
  }
}
