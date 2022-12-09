class Photo {
  Photo({
    this.id,
    this.url,
    this.media,
    this.thumb,
    this.width,
    this.height,
  });

  Photo.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    media = json['media'];
    thumb = json['thumb'];
    width = json['width'];
    height = json['height'];
  }

  String? id;
  String? url;
  String? media;
  String? thumb;
  int? width;
  int? height;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['media'] = media;
    map['thumb'] = thumb;
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}
