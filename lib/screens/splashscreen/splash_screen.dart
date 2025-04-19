import 'dart:async';

import 'package:e_learning_app/screens/AuthScreens/SignInScreen/sign_in_screen.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/student_dashboard.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/tutor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../customWidgets/customtext.dart';
import '../onboardScreen/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();

    Future.delayed(const Duration(seconds: 2), () async {
      if (authController.isLoggedIn()) {
        try {
          await authController.getProfile();

          final userType = authController.profileModel?.type;
          print("User type: $userType");

          if (userType == "Student") {
            Get.offAll(() => StudentDashboard(index: 0));
          } else if (userType == "Teacher" || userType == "Tutor") {
            Get.offAll(() => TutorDashboard());
          } else {
            Get.offAll(() => SignInScreen(type: "Unknown"));
          }
        } catch (e) {
          print("Error fetching profile: $e");
          Get.offAll(() => SignInScreen(type: "Unknown"));
        }
      } else {
        Get.offAll(() => OnboardScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Poppins(
              text: 'E-Learning',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Get.theme.secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }
}
