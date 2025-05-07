// To parse this JSON data, do
//
//     final allCourses = allCoursesFromJson(jsonString);

import 'dart:convert';

List<AllCourses> allCoursesFromJson(String str) => List<AllCourses>.from(json.decode(str).map((x) => AllCourses.fromJson(x)));

String allCoursesToJson(List<AllCourses> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllCourses {
  int? id;
  String? courseName;
  String? courseImage;
  int? teacherId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? contentsCount;

  AllCourses({
    this.id,
    this.courseName,
    this.courseImage,
    this.teacherId,
    this.createdAt,
    this.updatedAt,
    this.contentsCount,
  });

  factory AllCourses.fromJson(Map<String, dynamic> json) => AllCourses(
    id: json["id"],
    courseName: json["course_name"],
    courseImage: json["course_image"],
    teacherId: json["teacher_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    contentsCount: json["contents_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_name": courseName,
    "course_image": courseImage,
    "teacher_id": teacherId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "contents_count": contentsCount,
  };
}
