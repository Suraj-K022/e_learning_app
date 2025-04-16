// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  List<City>? city;

  CityModel({
    this.city,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    city: json["city"] == null ? [] : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x.toJson())),
  };
}

class City {
  int? id;
  String? name;
  int? stateId;
  DateTime? createdAt;
  DateTime? updatedAt;

  City({
    this.id,
    this.name,
    this.stateId,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
