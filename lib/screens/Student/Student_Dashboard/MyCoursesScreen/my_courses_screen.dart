import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/customtext.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          title: Poppins(
            text: 'My Courses',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        body: Center(
          child: Poppins(
            text: 'Nothing to Show',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Get.theme.hintColor,
          ),
        ));
  }
}
