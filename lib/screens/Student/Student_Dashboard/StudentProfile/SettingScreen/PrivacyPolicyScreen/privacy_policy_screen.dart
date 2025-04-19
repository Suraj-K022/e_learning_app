import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/course_Controller.dart';

import '../../../../../../customWidgets/customtext.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CourseController>().getPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Privacy Policy',
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
      body: GetBuilder<CourseController>(
        builder: (courseController) {
          if (courseController.getPrivacyPolicy.isEmpty) {
            return Center(
                child: CircularProgressIndicator(
              color: Get.theme.primaryColor,
            ));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            itemCount: courseController.getPrivacyPolicy.length,
            itemBuilder: (context, index) {
              return Poppins(
                text: courseController.getPrivacyPolicy[index].content ?? '',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                maxLines: 10,
                color: Get.theme.hintColor,
                textAlign: TextAlign.start,
              );
            },
          );
        },
      ),
    );
  }
}
