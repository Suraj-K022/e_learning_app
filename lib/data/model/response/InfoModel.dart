// To parse this JSON data, do
//
//     final infoModel = infoModelFromJson(jsonString);

import 'dart:convert';

InfoModel infoModelFromJson(String str) => InfoModel.fromJson(json.decode(str));

String infoModelToJson(InfoModel data) => json.encode(data.toJson());

class InfoModel {
  int? id;
  String? name;
  String? email;
  int? gender;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? mobileNumber;
  int? stateId;
  int? cityId;
  int? pinCode;
  String? address;
  String? profileImage;
  String? otp;
  dynamic mobileVerifiedAt;
  int? tempUser;
  int? isRefer;
  dynamic referCode;
  int? isReferDiscount;
  int? totalRefer;

  InfoModel({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.mobileNumber,
    this.stateId,
    this.cityId,
    this.pinCode,
    this.address,
    this.profileImage,
    this.otp,
    this.mobileVerifiedAt,
    this.tempUser,
    this.isRefer,
    this.referCode,
    this.isReferDiscount,
    this.totalRefer,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        mobileNumber: json["mobile_number"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        pinCode: json["pin_code"],
        address: json["address"],
        profileImage: json["profile_image"],
        otp: json["otp"],
        mobileVerifiedAt: json["mobile_verified_at"],
        tempUser: json["temp_user"],
        isRefer: json["is_refer"],
        referCode: json["refer_code"],
        isReferDiscount: json["is_refer_discount"],
        totalRefer: json["total_refer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "gender": gender,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "mobile_number": mobileNumber,
        "state_id": stateId,
        "city_id": cityId,
        "pin_code": pinCode,
        "address": address,
        "profile_image": profileImage,
        "otp": otp,
        "mobile_verified_at": mobileVerifiedAt,
        "temp_user": tempUser,
        "is_refer": isRefer,
        "refer_code": referCode,
        "is_refer_discount": isReferDiscount,
        "total_refer": totalRefer,
      };
}
