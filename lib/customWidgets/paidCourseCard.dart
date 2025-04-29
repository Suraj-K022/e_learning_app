import 'package:e_learning_app/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';

class PaidCourseCard extends StatelessWidget {
  // final CourseModel course;

  const PaidCourseCard({super.key, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen or payment logic
        // Get.to(() => CourseDetailPage(course: course));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.theme.cardColor,
        ),
        padding: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(

                width: double.infinity,
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
            // Title & Price
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,spacing: 10,
              children: [
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
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
                      
                      Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,spacing: 4,
                        children: [
                          Poppins(text: ' 600',fontWeight: FontWeight.w500,fontSize: 12,color: Get.theme.hintColor,textDecoration: TextDecoration.lineThrough,),
                          Poppins(text: '250',fontWeight: FontWeight.w500,fontSize: 12,color:Get.theme.canvasColor,),
                          Poppins(text: 'Rs',fontWeight: FontWeight.w500,fontSize: 12,color: Get.theme.hintColor,),
                  
                        ],
                      )
                      
                      
                    ],
                  ),
                ),
                Container(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),color:Colors.green.shade900),
                  child: Poppins(
                    text: 'Buy',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Get.theme.scaffoldBackgroundColor,
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
