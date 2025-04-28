import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentProfile/SettingScreen/setting_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddTestScreen/add_test_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/availableTestSeries/available_test_series.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/uploadedPdfsScreen/uploaded_pdfs_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/CoursesScreen/courses_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/PaymentScreen/payment_screen.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/NotificationScreen/notification_screen.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentProfile/SettingScreen/ProfileScreen/profile_screen.dart';
import 'package:e_learning_app/utils/images.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({super.key});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getProfile();
      Get.find<CourseController>().getAllCourses();
    });
  }

  Widget dashboardTile({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Get.theme.primaryColor),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(iconPath, color: Get.theme.secondaryHeaderColor),
            ),
            const SizedBox(height: 8),
            Poppins(
              text: title,
              fontSize: 16,
              maxLines: 3,
              color: Get.theme.secondaryHeaderColor,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: GetBuilder<AuthController>(
          builder: (authController) {
            if (authController.isLoading) {
              return Poppins(
                text: 'Loading...',
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              );
            }
            return Row(
              children: [
                InkWell(
                  onTap: () => Get.to(()=>ProfileScreen()),
                  child: CircleAvatar(
                    backgroundColor: Get.theme.secondaryHeaderColor,
                    radius: 20,
                    backgroundImage: (authController.profileModel?.image?.isNotEmpty ?? false)
                        ? NetworkImage(authController.profileModel!.image!)
                        : null,
                    child: (authController.profileModel?.image?.isEmpty ?? true)
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Poppins(
                  text: 'Hey, ${authController.profileModel?.name ?? "User"}',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.primaryColor,
                ),
              ],
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(()=>NotificationScreen()),
            child: Icon(Icons.notifications_active_outlined, size: 24, color: Get.theme.secondaryHeaderColor),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Get.to(()=>SettingScreen()),
            child: Image.asset(Images.settings, height: 20, width: 20),
          ),
          const SizedBox(width: 36),
        ],
      ),
      body: GetBuilder<CourseController>(
        builder: (courseController) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              // dashboardTile(
              //   title: 'Create New Course',
              //   iconPath: Images.add,
              //   onTap: () => Get.to(CreateNewCourse(
              //
              //
              //     courseName: '',
              //     ScreenName: 'TutorDashboard',
              //   )),
              // ),
              dashboardTile(
                title: 'Courses',
                iconPath: Images.course,
                onTap: () => Get.to(()=>CoursesScreen()),
              ),
              // dashboardTile(
              //   title: 'Create Test',
              //   iconPath: Images.test,
              //   onTap: () => Get.to(AddTestScreen()),
              // ),
              dashboardTile(
                title: 'Test Series',
                iconPath: Images.test,
                onTap: () => Get.to(()=>AvailableTestSeries()),
              ),
              dashboardTile(
                title: 'Uploaded Pdfs',
                iconPath: Images.i5,
                onTap: () => Get.to(()=>UploadedPdfsScreen()),
              ),
              dashboardTile(
                title: 'Payments',
                iconPath: Images.wallet,
                onTap: () => Get.to(()=>PaymentScreen()),
              ),
            ],
          );
        },
      ),
    );
  }
}