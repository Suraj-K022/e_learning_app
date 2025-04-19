import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../customWidgets/customtext.dart';
import '../../../themedata/theme_data.dart';

import '../../../utils/images.dart';
import 'MyCoursesScreen/my_courses_screen.dart';
import 'StudentHome/student_home.dart';
import 'StudentProfile/student_profile.dart';

class StudentDashboard extends StatefulWidget {
  final int index;

  const StudentDashboard({super.key, required this.index});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final ThemeController themeController = Get.find();

  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  Widget getCurrentScreen() {
    switch (index) {
      case 0:
        return StudentHome();
      case 1:
        return MyCoursesScreen();
      case 2:
        return StudentProfile();
      default:
        return StudentHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentScreen(),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Colors.black.withOpacity(0.9) // Dark mode color
                  : Colors.white.withOpacity(0.9), // Light mode color
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 90,
            child: Row(
              children: [
                _buildNavItem(
                    0, Images.dashboard, Images.dashboarddark, 'Dashboard'),
                _buildNavItem(
                    1, Images.mycourse, Images.mycoursedark, 'My Courses'),
                _buildNavItem(
                    2, Images.customer, Images.customerdark, 'Profile'),
              ],
            ),
          )),
    );
  }

  Widget _buildNavItem(
      int itemIndex, String lightIcon, String darkIcon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            index = itemIndex;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Image.asset(
              index == itemIndex ? darkIcon : lightIcon,
              height: 24,
              width: 24,
              fit: BoxFit.cover,
            ),
            Poppins(
              textAlign: TextAlign.center,
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: index == itemIndex
                  ? Get.theme.primaryColor
                  : Get.theme.secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }
}
