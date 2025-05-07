// To parse this JSON data, do
//
//     final paidCoursesModel = paidCoursesModelFromJson(jsonString);

import 'dart:convert';

List<PaidCoursesModel> paidCoursesModelFromJson(String str) => List<PaidCoursesModel>.from(json.decode(str).map((x) => PaidCoursesModel.fromJson(x)));

String paidCoursesModelToJson(List<PaidCoursesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaidCoursesModel {
  int? id;
  String? teacherName;
  String? title;
  String? price;
  String? discount;
  String? image;
  int? teacherId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? contentsCount;

  PaidCoursesModel({
    this.id,
    this.teacherName,
    this.title,
    this.price,
    this.discount,
    this.image,
    this.teacherId,
    this.createdAt,
    this.updatedAt,
    this.contentsCount,
  });

  factory PaidCoursesModel.fromJson(Map<String, dynamic> json) => PaidCoursesModel(
    id: json["id"],
    teacherName: json["teacher_name"],
    title: json["title"],
    price: json["price"],
    discount: json["discount"],
    image: json["image"],
    teacherId: json["teacher_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    contentsCount: json["contents_count"],
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
    "contents_count": contentsCount,
  };
}
