// To parse this JSON data, do
//
//     final pdfNotesModel = pdfNotesModelFromJson(jsonString);

import 'dart:convert';

List<PdfNotesModel> pdfNotesModelFromJson(String str) => List<PdfNotesModel>.from(json.decode(str).map((x) => PdfNotesModel.fromJson(x)));

String pdfNotesModelToJson(List<PdfNotesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PdfNotesModel {
  String? name;
  String? pdfUrl;
  String? imageUrl;

  PdfNotesModel({
    this.name,
    this.pdfUrl,
    this.imageUrl,
  });

  factory PdfNotesModel.fromJson(Map<String, dynamic> json) => PdfNotesModel(
    name: json["name"],
    pdfUrl: json["pdf_url"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "pdf_url": pdfUrl,
    "image_url": imageUrl,
  };
}
