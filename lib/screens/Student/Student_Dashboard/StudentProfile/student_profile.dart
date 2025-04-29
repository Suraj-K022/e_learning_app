import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/custom_switch.dart';
import '../../../../customWidgets/customtext.dart';
import '../../../../themedata/theme_data.dart';
import '../../../../utils/images.dart';

import 'FAQsScreen/faqs_screen.dart';
import 'SettingScreen/setting_screen.dart';

class StudentProfile extends StatelessWidget {
  StudentProfile({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'User',
          color: Get.theme.secondaryHeaderColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          ListTile(
            onTap: () => Get.to(() => SettingScreen()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Get.theme.cardColor,
            leading: Image.asset(Images.setting, height: 24, width: 24),
            title: Poppins(
              text: 'Settings',
              fontWeight: FontWeight.w400,
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          ),
          const SizedBox(height: 10),
          ListTile(
            onTap: () => Get.to(() => FaqsScreen()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Get.theme.cardColor,
            leading: Image.asset(Images.faq, height: 24, width: 24),
            title: Poppins(
              text: 'FAQs',
              fontWeight: FontWeight.w400,
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
          ),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Get.theme.cardColor,
            leading: Icon(Icons.dark_mode_outlined, color: Get.theme.secondaryHeaderColor),
            title: Poppins(
              text: themeController.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
              fontWeight: FontWeight.w400,
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
            ),
            trailing: CustomSwitch(
              onChanged: (value) => themeController.toggleTheme(),
              initialValue: themeController.isDarkMode.value,
            ),
          ),
        ],
      ),
    ));
  }
}
