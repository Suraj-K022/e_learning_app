import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/images.dart';

class PaidCourseCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PaidCourseCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the passed-in onTap callback
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.cardColor,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.b4),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Poppins(
                        text: 'titleksjdfbsdkjffbsdkjbfcsdkjcb',
                        maxLines: 3,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                      Poppins(
                        text: 'By UserName',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Get.theme.hintColor,
                      ),
                      Row(
                        children: [
                          Poppins(
                            text: '600',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Get.theme.hintColor,
                            textDecoration: TextDecoration.lineThrough,
                          ),
                          SizedBox(width: 4),
                          Poppins(
                            text: '250',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Get.theme.canvasColor,
                          ),
                          SizedBox(width: 4),
                          Poppins(
                            text: 'Rs',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Get.theme.hintColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.green.shade900,
                  ),
                  child: Poppins(
                    text: 'View Course',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
