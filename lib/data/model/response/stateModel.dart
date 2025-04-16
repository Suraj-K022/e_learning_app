// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'dart:convert';

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  List<State>? state;

  StateModel({
    this.state,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    state: json["state"] == null ? [] : List<State>.from(json["state"]!.map((x) => State.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x.toJson())),
  };
}

class State {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  State({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
