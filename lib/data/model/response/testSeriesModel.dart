// To parse this JSON data, do
//
//     final testSeriesModel = testSeriesModelFromJson(jsonString);

import 'dart:convert';

List<TestSeriesModel> testSeriesModelFromJson(String str) =>
    List<TestSeriesModel>.from(
        json.decode(str).map((x) => TestSeriesModel.fromJson(x)));

String testSeriesModelToJson(List<TestSeriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestSeriesModel {
  int? id;
  String? title;
  String? thumbnail;

  TestSeriesModel({
    this.id,
    this.title,
    this.thumbnail,
  });

  factory TestSeriesModel.fromJson(Map<String, dynamic> json) =>
      TestSeriesModel(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
      };
}
