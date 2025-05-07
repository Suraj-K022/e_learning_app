// To parse this JSON data, do
//
//     final paidCoursesContentsModel = paidCoursesContentsModelFromJson(jsonString);

import 'dart:convert';

List<PaidCoursesContentsModel> paidCoursesContentsModelFromJson(String str) => List<PaidCoursesContentsModel>.from(json.decode(str).map((x) => PaidCoursesContentsModel.fromJson(x)));

String paidCoursesContentsModelToJson(List<PaidCoursesContentsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaidCoursesContentsModel {
  int? id;
  int? courseId;
  String? title;
  String? description;
  Course? course;
  String? contentImage;
  dynamic videoUpload;
  String? pdfUpload;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaidCoursesContentsModel({
    this.id,
    this.courseId,
    this.title,
    this.description,
    this.course,
    this.contentImage,
    this.videoUpload,
    this.pdfUpload,
    this.createdAt,
    this.updatedAt,
  });

  factory PaidCoursesContentsModel.fromJson(Map<String, dynamic> json) => PaidCoursesContentsModel(
    id: json["id"],
    courseId: json["course_id"],
    title: json["title"],
    description: json["description"],
    course: json["course"] == null ? null : Course.fromJson(json["course"]),
    contentImage: json["content_image"],
    videoUpload: json["video_upload"],
    pdfUpload: json["pdf_upload"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "title": title,
    "description": description,
    "course": course?.toJson(),
    "content_image": contentImage,
    "video_upload": videoUpload,
    "pdf_upload": pdfUpload,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Course {
  int? id;
  String? teacherName;
  String? title;
  String? price;
  String? discount;
  String? image;
  int? teacherId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Course({
    this.id,
    this.teacherName,
    this.title,
    this.price,
    this.discount,
    this.image,
    this.teacherId,
    this.createdAt,
    this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    teacherName: json["teacher_name"],
    title: json["title"],
    price: json["price"],
    discount: json["discount"],
    image: json["image"],
    teacherId: json["teacher_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacher_name": teacherName,
    "title": title,
    "price": price,
    "discount": discount,
    "image": image,
    "teacher_id": teacherId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
