import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customtext.dart';

class TestSeriesWidget extends StatelessWidget {
  final String title;
  final String image;

  const TestSeriesWidget({
    super.key,
    required this.title,
    required this.image,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Get.theme.scaffoldBackgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Poppins(
                      text: 'MCQs',
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      maxLines: 1,
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
