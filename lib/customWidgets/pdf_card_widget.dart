import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customtext.dart';

class PdfCard extends StatelessWidget {
  final String title;
  final String description;
  final String imgUrl;
  // final Color color;

  const PdfCard({
    super.key,
    required this.title,
    required this.description,
    // required this.color,
    required this.imgUrl,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Get.theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                      overflow: TextOverflow.ellipsis,
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
