// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? username;
  String? bio;
  String? type;
  String? image;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.username,
    this.bio,
    this.type,
    this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    username: json["username"],
    bio: json["bio"],
    type: json["type"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "username": username,
    "bio": bio,
    "type": type,
    "image": image,
  };
}
