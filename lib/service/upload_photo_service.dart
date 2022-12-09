import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:manga_app/model/photo.dart';

class UploadPhotoService {
  static final _service = UploadPhotoService._internal();

  factory UploadPhotoService() => _service;

  UploadPhotoService._internal();

  Future request({
    required XFile file,
  }) async {
    final uri = Uri.parse('https://thumbsnap.com/api/upload/');
    http.Response response;
    final request = http.MultipartRequest('POST', uri);
    request.files.addAll([
      http.MultipartFile.fromBytes(
        'media',
        await file.readAsBytes(),
        filename: file.path.split('/').last,
      ),
      http.MultipartFile.fromString(
        'key',
        '000025e91353ec8eafc62a1f6e56f5da',
      ),
    ]);
    final stream = await request.send();
    response = await http.Response.fromStream(stream);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);

      final data = json['data'];
      return data;
    }
  }

  Future<Photo> uploadAvatar({required XFile file}) async {
    final result = await request(file: file);
    final photo = Photo.fromJson(result);

    return photo;
  }
}

final apiUploadPhotoService = UploadPhotoService();
