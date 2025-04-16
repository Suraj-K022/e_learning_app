import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Poppins extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  const Poppins({
    Key? key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines, // New maxLines parameter
    this.overflow, // New overflow parameter
    this.textDecoration, // New textDecoration parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines, // Limits number of lines
      overflow: overflow ?? TextOverflow.ellipsis, // Handles overflow text
      style: GoogleFonts.poppins(
        fontSize: fontSize ?? 12,
        color: color ?? Get.theme.primaryColor,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none, // Default to no decoration
      ),
    );
  }
}
//
// class Rubik extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   final TextAlign? textAlign;
//   final double? letterSpacing;
//   final int? maxLines;
//   final TextOverflow? overflow;
//   final TextDecoration? textDecoration;
//
//   const Rubik({
//     Key? key,
//     required this.text,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.textAlign,
//     this.letterSpacing,
//     this.maxLines, // New maxLines parameter
//     this.overflow, // New overflow parameter
//     this.textDecoration, // New textDecoration parameter
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       textAlign: textAlign ?? TextAlign.start,
//       maxLines: maxLines,
//       overflow: overflow ?? TextOverflow.ellipsis,
//       style: GoogleFonts.rubik(
//         fontSize: fontSize ?? 12,
//         color: color ?? Get.theme.primaryColor,
//         fontWeight: fontWeight ?? FontWeight.normal,
//         letterSpacing: letterSpacing ?? 0.5,
//         decoration: textDecoration ?? TextDecoration.none,
//       ),
//     );
//   }
// }
