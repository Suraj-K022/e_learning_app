import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../customWidgets/customtext.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     Get.find<CourseController>().getTermsAndCondition();
   },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Terms & Conditions',
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
          if (courseController.getTermsCondition.isEmpty) {
            return Center(
                child: CircularProgressIndicator(
              color: Get.theme.primaryColor,
            ));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            itemCount: courseController.getTermsCondition.length,
            itemBuilder: (context, index) {
              return Poppins(
                text: courseController.getTermsCondition[index].content ?? '',
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
