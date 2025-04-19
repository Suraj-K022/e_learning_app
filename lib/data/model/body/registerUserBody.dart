// To parse this JSON data, do
//
//     final registerUserBody = registerUserBodyFromJson(jsonString);

import 'dart:convert';

RegisterUserBody registerUserBodyFromJson(String str) =>
    RegisterUserBody.fromJson(json.decode(str));

String registerUserBodyToJson(RegisterUserBody data) =>
    json.encode(data.toJson());

class RegisterUserBody {
  String? name;
  String? mobile;
  String? email;
  String? password;
  String? type;
  String? passwordConfirmation;

  RegisterUserBody({
    this.name,
    this.mobile,
    this.email,
    this.password,
    this.type,
    this.passwordConfirmation,
  });

  factory RegisterUserBody.fromJson(Map<String, dynamic> json) =>
      RegisterUserBody(
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        type: json["type"],
        passwordConfirmation: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "email": email,
        "password": password,
        "type": type,
        "password_confirmation": passwordConfirmation,
      };
}
