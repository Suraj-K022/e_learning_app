import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentProfile/SettingScreen/setting_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddTestScreen/add_test_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/PaidCoursesList/paid_courses_list.dart';
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
      // Get.find<CourseController>().getAllCourses();
    });
  }

  Widget dashboardTile({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Get.theme.primaryColor.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 36,
              width: 36,
              color: Get.theme.secondaryHeaderColor,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: title,
              fontSize: 14,
              maxLines: 2,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
              color: Get.theme.secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: GetBuilder<AuthController>(
          builder: (authController) {
            if (authController.isLoading) {
              return SizedBox(height: 24,width: 24,child: CircularProgressIndicator(backgroundColor: Get.theme.scaffoldBackgroundColor,color: Get.theme.primaryColor,));
            }
            return Row(
              children: [
                InkWell(
                  onTap: () => Get.to(() => const ProfileScreen()),
                  child: CircleAvatar(
                    backgroundColor: Get.theme.secondaryHeaderColor,
                    radius: 20,
                    backgroundImage: (authController.profileModel?.image?.isNotEmpty ?? false)
                        ? NetworkImage(authController.profileModel!.image!)
                        : null,
                    child: (authController.profileModel?.image?.isEmpty ?? true)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Poppins(
                    text: 'Hey, ${authController.profileModel?.name ?? "User"}',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.primaryColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(() => const NotificationScreen()),
            child: Icon(Icons.notifications_active_outlined, size: 24, color: Get.theme.secondaryHeaderColor),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Get.to(() => const SettingScreen()),
            child: Image.asset(Images.settings, height: 20, width: 20),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: GetBuilder<CourseController>(
        builder: (courseController) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      dashboardTile(
                        title: 'Create Free Courses',
                        iconPath: Images.course,
                        onTap: () => Get.to(() => const CoursesScreen()),
                      ),
                      dashboardTile(
                        title: 'Create Paid Courses',
                        iconPath: Images.test,
                        onTap: () => Get.to(() => const PaidCoursesList()),
                      ),
                      dashboardTile(
                        title: 'Test Series',
                        iconPath: Images.test,
                        onTap: () => Get.to(() => const AvailableTestSeries()),
                      ),
                      dashboardTile(
                        title: 'Uploaded Pdfs',
                        iconPath: Images.i5,
                        onTap: () => Get.to(() => const UploadedPdfsScreen()),
                      ),
                      dashboardTile(
                        title: 'Payments',
                        iconPath: Images.wallet,
                        onTap: () => Get.to(() => const PaymentScreen()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
