import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/course_Controller.dart';
import 'customtext.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String count;


  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.count,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {

  @override
  Widget build(BuildContext context) {
    return
      GetBuilder<CourseController>(builder: (courseController) {
        return

          Container(
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
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      widget.imageUrl,
                      width: Get.width,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(

                      child: Poppins(
                        text: widget.title,
                        color: Get.theme.secondaryHeaderColor,
                        fontWeight: FontWeight.w400,
                        // maxLines: 2,
                        overflow:TextOverflow.ellipsis,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Poppins(
                        textAlign: TextAlign.end,
                        text: '${widget.count} Topics',
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Poppins(
                        text: widget.description,
                        color: Get.theme.hintColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,size: 16,color: Get.theme.secondaryHeaderColor,)
                  ],
                ),
              ],
            ),
          );

      },);

  }
}
