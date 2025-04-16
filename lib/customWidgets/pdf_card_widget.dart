import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'customtext.dart';

class PdfCard extends StatelessWidget {
  final String title;
  final String description;
  final String imgUrl ;
  final Color color;

  const PdfCard({
    super.key,
    required this.title,
    required this.description,
    required this.color, required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Get.theme.cardColor,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // color: color,
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: Get.width,
                height: 30,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Poppins(
                text: title,
                color: Get.theme.secondaryHeaderColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              Row(
                children: [
                  Expanded(
                    child: Poppins(
                      text: description,
                      color: Get.theme.hintColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      maxLines: 2,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Get.theme.secondaryHeaderColor,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
