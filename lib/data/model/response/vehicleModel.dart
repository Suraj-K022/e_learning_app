// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) => List<VehicleModel>.from(
    json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleModel {
  int? id;
  String? title;
  int? status;
  String? weight;
  String? charge;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? maxDistance;
  int? minDistance;
  String? time;

  VehicleModel({
    this.id,
    this.title,
    this.status,
    this.weight,
    this.charge,
    this.icon,
    this.createdAt,
    this.updatedAt,
    this.maxDistance,
    this.minDistance,
    this.time,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        weight: json["weight"],
        charge: json["charge"],
        icon: json["icon"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        maxDistance: json["max_distance"],
        minDistance: json["min_distance"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "weight": weight,
        "charge": charge,
        "icon": icon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "max_distance": maxDistance,
        "min_distance": minDistance,
        "time": time,
      };
}
