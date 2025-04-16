import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customtext.dart';

class TestSeriesWidget extends StatelessWidget {
  final String title;

  final String image;
  const TestSeriesWidget({super.key, required this.title, required this.image, });

  @override
  Widget build(BuildContext context) {
    return


      Container(
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
                 image,
                  width: Get.width,

                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Poppins(
                        text: title,
                        color: Get.theme.secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,color: Get.theme.secondaryHeaderColor,size: 16,)
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Poppins(
                //         text: 'description',
                //         color: Get.theme.hintColor,
                //         fontWeight: FontWeight.w400,
                //         fontSize: 14,
                //         maxLines: 2,
                //       ),
                //     ),
                //     Icon(
                //       Icons.arrow_forward_ios,
                //       color: Get.theme.secondaryHeaderColor,
                //       size: 16,
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      );

  }
}



