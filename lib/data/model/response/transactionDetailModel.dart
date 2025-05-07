// To parse this JSON data, do
//
//     final transactionDetailsModel = transactionDetailsModelFromJson(jsonString);

import 'dart:convert';

List<TransactionDetailsModel> transactionDetailsModelFromJson(String str) => List<TransactionDetailsModel>.from(json.decode(str).map((x) => TransactionDetailsModel.fromJson(x)));

String transactionDetailsModelToJson(List<TransactionDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionDetailsModel {
  int? id;
  String? courseName;
  String? studentName;
  String? paymentMethod;
  String? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  TransactionDetailsModel({
    this.id,
    this.courseName,
    this.studentName,
    this.paymentMethod,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionDetailsModel.fromJson(Map<String, dynamic> json) => TransactionDetailsModel(
    id: json["id"],
    courseName: json["course_name"],
    studentName: json["student_name"],
    paymentMethod: json["payment_method"],
    amount: json["amount"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_name": courseName,
    "student_name": studentName,
    "payment_method": paymentMethod,
    "amount": amount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
