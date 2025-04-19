// To parse this JSON data, do
//
//     final addContentModel = addContentModelFromJson(jsonString);

import 'dart:convert';

AddContentModel addContentModelFromJson(String str) =>
    AddContentModel.fromJson(json.decode(str));

String addContentModelToJson(AddContentModel data) =>
    json.encode(data.toJson());

class AddContentModel {
  int? status;
  String? message;
  Content? content;

  AddContentModel({
    this.status,
    this.message,
    this.content,
  });

  factory AddContentModel.fromJson(Map<String, dynamic> json) =>
      AddContentModel(
        status: json["status"],
        message: json["message"],
        content:
            json["content"] == null ? null : Content.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "content": content?.toJson(),
      };
}

class Content {
  String? title;
  String? description;
  String? course;
  String? contentImage;
  String? vedioUpload;
  String? pdfUpload;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Content({
    this.title,
    this.description,
    this.course,
    this.contentImage,
    this.vedioUpload,
    this.pdfUpload,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        title: json["title"],
        description: json["description"],
        course: json["course"],
        contentImage: json["content_image"],
        vedioUpload: json["vedio_upload"],
        pdfUpload: json["pdf_upload"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "course": course,
        "content_image": contentImage,
        "vedio_upload": vedioUpload,
        "pdf_upload": pdfUpload,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
