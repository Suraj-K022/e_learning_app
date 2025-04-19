// To parse this JSON data, do
//
//     final offerModel = offerModelFromJson(jsonString);

import 'dart:convert';

List<OfferModel> offerModelFromJson(String str) =>
    List<OfferModel>.from(json.decode(str).map((x) => OfferModel.fromJson(x)));

String offerModelToJson(List<OfferModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferModel {
  int? id;
  String? tittle;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
  int? amount;
  String? code;

  OfferModel({
    this.id,
    this.tittle,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.amount,
    this.code,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        tittle: json["tittle"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"],
        amount: json["amount"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tittle": tittle,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "amount": amount,
        "code": code,
      };
}
