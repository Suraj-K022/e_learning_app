// To parse this JSON data, do
//
//     final allContentModel = allContentModelFromJson(jsonString);

import 'dart:convert';

List<AllContentModel> allContentModelFromJson(String str) =>
    List<AllContentModel>.from(
        json.decode(str).map((x) => AllContentModel.fromJson(x)));

String allContentModelToJson(List<AllContentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllContentModel {
  int? id;
  String? title;
  String? description;
  int? courseId;
  String? contentImage;
  List<String>? vedioUpload;
  List<String>? pdfUpload;

  AllContentModel({
    this.id,
    this.title,
    this.description,
    this.courseId,
    this.contentImage,
    this.vedioUpload,
    this.pdfUpload,
  });

  factory AllContentModel.fromJson(Map<String, dynamic> json) =>
      AllContentModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        courseId: json["course_id"],
        contentImage: json["content_image"],
        vedioUpload: json["vedio_upload"] == null
            ? []
            : List<String>.from(json["vedio_upload"]!.map((x) => x)),
        pdfUpload: json["pdf_upload"] == null
            ? []
            : List<String>.from(json["pdf_upload"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "course_id": courseId,
        "content_image": contentImage,
        "vedio_upload": vedioUpload == null
            ? []
            : List<dynamic>.from(vedioUpload!.map((x) => x)),
        "pdf_upload": pdfUpload == null
            ? []
            : List<dynamic>.from(pdfUpload!.map((x) => x)),
      };
}
