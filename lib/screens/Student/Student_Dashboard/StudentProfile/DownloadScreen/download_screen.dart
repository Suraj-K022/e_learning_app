import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../customWidgets/course_card_widget.dart';
import '../../../../../customWidgets/customtext.dart';
import '../../../../../utils/images.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Downloads',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () {
            Get.back(canPop: true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          CourseCard(
            count: '',
            imageUrl: Images.dummyimg,
            title: 'title',
            description: 'description',
          ),
          CourseCard(
            count: '',
            imageUrl: Images.dummyimg,
            title: 'title',
            description: 'description',
          ),
          CourseCard(
            count: '',
            imageUrl: Images.dummyimg,
            title: 'title',
            description: 'description',
          ),
          CourseCard(
            count: '',
            imageUrl: Images.dummyimg,
            title: 'title',
            description: 'description',
          ),
        ],
      ),
    );
  }
}
