// To parse this JSON data, do
//
//     final termsConditionModel = termsConditionModelFromJson(jsonString);

import 'dart:convert';

List<TermsConditionModel> termsConditionModelFromJson(String str) =>
    List<TermsConditionModel>.from(
        json.decode(str).map((x) => TermsConditionModel.fromJson(x)));

String termsConditionModelToJson(List<TermsConditionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TermsConditionModel {
  int? id;
  String? content;

  TermsConditionModel({
    this.id,
    this.content,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) =>
      TermsConditionModel(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}
