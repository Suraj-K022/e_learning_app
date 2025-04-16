// To parse this JSON data, do
//
//     final mcqModel = mcqModelFromJson(jsonString);

import 'dart:convert';

List<McqModel> mcqModelFromJson(String str) => List<McqModel>.from(json.decode(str).map((x) => McqModel.fromJson(x)));

String mcqModelToJson(List<McqModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class McqModel {
  int? id;
  String? question;
  List<String>? options;
  String? answer;

  McqModel({
    this.id,
    this.question,
    this.options,
    this.answer,
  });

  factory McqModel.fromJson(Map<String, dynamic> json) => McqModel(
    id: json["id"],
    question: json["question"],
    options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
    "answer": answer,
  };
}
