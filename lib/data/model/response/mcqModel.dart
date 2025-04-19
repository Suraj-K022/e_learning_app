// To parse this JSON data, do
//
//     final mcqModel = mcqModelFromJson(jsonString);

import 'dart:convert';

List<McqModel> mcqModelFromJson(String str) =>
    List<McqModel>.from(json.decode(str).map((x) => McqModel.fromJson(x)));

String mcqModelToJson(List<McqModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class McqModel {
  int? id;
  String? questionText;
  String? optionA;
  String? optionB;
  String? optionC;
  String? optionD;
  String? correctOption;

  McqModel({
    this.id,
    this.questionText,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.correctOption,
  });

  factory McqModel.fromJson(Map<String, dynamic> json) => McqModel(
        id: json["id"],
        questionText: json["question_text"],
        optionA: json["option_a"],
        optionB: json["option_b"],
        optionC: json["option_c"],
        optionD: json["option_d"],
        correctOption: json["correct_option"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "option_a": optionA,
        "option_b": optionB,
        "option_c": optionC,
        "option_d": optionD,
        "correct_option": correctOption,
      };
}
