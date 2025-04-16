import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable variable to track current theme mode
  RxBool isDarkMode = false.obs;

  // Method to toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }
}

// Define Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  primaryColor: Color(0xFF1E88E5),
  canvasColor: Color(0xffFF0000),
  secondaryHeaderColor: Color(0xFFECF0F1),
  hintColor: Color(0xFF707070),
  cardColor: Colors.grey.shade900,
);

// Define Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  primaryColor: Color(0xFF1E88E5),
  canvasColor: Color(0xffFF0000),
  secondaryHeaderColor: Colors.grey.shade900,
  hintColor: Color(0xFF707070),
  cardColor: Colors.grey.shade200,
);
