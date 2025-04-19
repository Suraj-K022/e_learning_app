// To parse this JSON data, do
//
//     final allCourses = allCoursesFromJson(jsonString);

import 'dart:convert';

List<AllCourses> allCoursesFromJson(String str) =>
    List<AllCourses>.from(json.decode(str).map((x) => AllCourses.fromJson(x)));

String allCoursesToJson(List<AllCourses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllCourses {
  int? id;
  String? courseName;
  String? courseImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalContent;

  AllCourses({
    this.id,
    this.courseName,
    this.courseImage,
    this.createdAt,
    this.updatedAt,
    this.totalContent,
  });

  factory AllCourses.fromJson(Map<String, dynamic> json) => AllCourses(
        id: json["id"],
        courseName: json["course_name"],
        courseImage: json["course_image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        totalContent: json["total_content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_name": courseName,
        "course_image": courseImage,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_content": totalContent,
      };
}
