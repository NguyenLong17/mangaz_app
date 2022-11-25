class Manga {
  Manga({
      this.name, 
      this.avatar, 
      this.author, 
      this.anotherName, 
      this.favorite, 
      this.view, 
      this.content, 
      this.tag, 
      this.chapter, 
      this.id,});

  Manga.fromJson(dynamic json) {
    name = json['name'];
    avatar = json['avatar'];
    author = json['author'];
    anotherName = json['anotherName'];
    favorite = json['favorite'];
    view = json['view'];
    content = json['content'];
    if (json['tag'] != null) {
      tag = [];
      json['tag'].forEach((v) {
        tag?.add(Tag.fromJson(v));
      });
    }
    if (json['chapter'] != null) {
      chapter = [];
      json['chapter'].forEach((v) {
        chapter?.add(Chapter.fromJson(v));
      });
    }
    id = json['id'];
  }
  String? name;
  String? avatar;
  String? author;
  String? anotherName;
  bool? favorite;
  int? view;
  String? content;
  List<Tag>? tag;
  List<Chapter>? chapter;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['author'] = author;
    map['anotherName'] = anotherName;
    map['favorite'] = favorite;
    map['view'] = view;
    map['content'] = content;
    if (tag != null) {
      map['tag'] = tag?.map((v) => v.toJson()).toList();
    }
    if (chapter != null) {
      map['chapter'] = chapter?.map((v) => v.toJson()).toList();
    }
    map['id'] = id;
    return map;
  }

}

class Chapter {
  Chapter({
      this.name, 
      this.image,});

  Chapter.fromJson(dynamic json) {
    name = json['name'];
    image = json['image'] != null ? json['image'].cast<String>() : [];
  }
  String? name;
  List<String>? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}

class Tag {
  Tag({
      this.id, 
      this.name, 
      this.description,});

  Tag.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }
  String? id;
  String? name;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    return map;
  }

}