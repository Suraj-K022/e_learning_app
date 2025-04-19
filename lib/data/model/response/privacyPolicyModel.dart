// To parse this JSON data, do
//
//     final privacyPolicyModel = privacyPolicyModelFromJson(jsonString);

import 'dart:convert';

List<PrivacyPolicyModel> privacyPolicyModelFromJson(String str) =>
    List<PrivacyPolicyModel>.from(
        json.decode(str).map((x) => PrivacyPolicyModel.fromJson(x)));

String privacyPolicyModelToJson(List<PrivacyPolicyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrivacyPolicyModel {
  int? id;
  String? content;

  PrivacyPolicyModel({
    this.id,
    this.content,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyModel(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}
