import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:manga_app/common/const/const.dart';
import 'package:manga_app/model/user.dart';

class APIService {
  static final _service = APIService._internal();

  factory APIService() => _service;

  User? user;

  APIService._internal();

  Future request({
    Method method = Method.get,
    required String path,
    Map<String, dynamic>? body,
    XFile? file,
  }) async {
    final uri = Uri.parse(baseUrl + path);
    http.Response response;
    // var responseJson;
    // final headers = {
    //   'Authorization': 'Bearer ${user?.token}',
    // };

    if (file != null) {
      final request = http.MultipartRequest('POST', uri);
      // request.headers.addAll(headers);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        await file.readAsBytes(),
        filename: file.path.split('/').last,
      ));
      final stream = await request.send();
      response = await http.Response.fromStream(stream);
    } else {
      switch (method) {
        case Method.get:
          response = await http.get(
            uri,
          );
          break;
        case Method.put:
          response = await http.put(uri, body: body, encoding: utf8);
          break;
        case Method.delete:
          response = await http.delete(uri, body: body, encoding: utf8);
          break;
        default:
          response = await http.post(uri, body: body, encoding: utf8);
          break;
      }
    }

    final responseJson = json.decode(utf8.decode(response.bodyBytes));

    return responseJson;
  }
}

final apiService = APIService();

enum Method { get, post, put, delete }
