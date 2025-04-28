import 'package:e_learning_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/custom_switch.dart';
import '../../../../customWidgets/customtext.dart';
import '../../../../themedata/theme_data.dart';

import 'DownloadScreen/download_screen.dart';
import 'FAQsScreen/faqs_screen.dart';
import 'SettingScreen/ProfileScreen/profile_screen.dart';
import 'SettingScreen/setting_screen.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
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
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [




              // ListTile(
              //   onTap: () {
              //     Get.to(DownloadScreen());
              //   },
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(8))),
              //   tileColor: Get.theme.cardColor,
              //   leading: Image.asset(
              //     Images.download,
              //     height: 24,
              //     width: 24,
              //     fit: BoxFit.cover,
              //   ),
              //   title: Poppins(
              //     text: 'Downloads',
              //     fontWeight: FontWeight.w400,
              //     color: Get.theme.secondaryHeaderColor,
              //     fontSize: 16,
              //   ),
              //   trailing: Icon(
              //     Icons.arrow_forward_ios,
              //     size: 20,
              //     color: Get.theme.secondaryHeaderColor,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              ListTile(
                onTap: () {
                  Get.to(()=>SettingScreen());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                tileColor: Get.theme.cardColor,
                leading: Image.asset(
                  Images.setting,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
                title: Poppins(
                  text: 'Settings',
                  fontWeight: FontWeight.w400,
                  color: Get.theme.secondaryHeaderColor,
                  fontSize: 16,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Get.theme.secondaryHeaderColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Get.to(()=>FaqsScreen());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                tileColor: Get.theme.cardColor,
                leading: Image.asset(
                  Images.faq,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
                title: Poppins(
                  text: 'FAQs',
                  fontWeight: FontWeight.w400,
                  color: Get.theme.secondaryHeaderColor,
                  fontSize: 16,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Get.theme.secondaryHeaderColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                tileColor:
                    Get.theme.cardColor, // This will now update immediately
                leading: Image.asset(Images.faq,
                    height: 24, width: 24, fit: BoxFit.cover),
                title: Poppins(
                  text: themeController.isDarkMode.value
                      ? 'Dark Mode '
                      : 'Light Mode',
                  fontWeight: FontWeight.w400,
                  color: Get.theme.secondaryHeaderColor,
                  fontSize: 16,
                ),
                trailing: CustomSwitch(
                  onChanged: (value) => themeController.toggleTheme(),
                  initialValue: themeController.isDarkMode.value,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
