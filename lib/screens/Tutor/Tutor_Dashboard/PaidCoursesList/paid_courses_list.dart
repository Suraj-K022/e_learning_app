import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/tutor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../customWidgets/custom_buttons.dart';
import '../../../../customWidgets/customtext.dart';
import 'AddNewPaidCourse/PaidCourseContentList/paid_course_content_list.dart';
import 'AddNewPaidCourse/add_new_paid_course.dart';

class PaidCoursesList extends StatefulWidget {
  const PaidCoursesList({super.key});

  @override
  State<PaidCoursesList> createState() => _PaidCoursesListState();
}

class _PaidCoursesListState extends State<PaidCoursesList> {
  final Set<int> _showDelete = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getMyPaidCourses();
    });
  }

  Future<void> _refreshCourses() async {
    await Get.find<CourseController>().getMyPaidCourses();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          title: Poppins(
            text: 'Paid Courses',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
            onPressed: () => Get.off(TutorDashboard()),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshCourses,
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: controller.myPaidCourses.isEmpty
              ? Center(child: Poppins(text: 'No Course found',fontWeight: FontWeight.w500,fontSize: 14,color: Get.theme.secondaryHeaderColor,))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.myPaidCourses.length,
            itemBuilder: (context, index) {
              final course = controller.myPaidCourses[index];
              final isDeleteVisible = _showDelete.contains(index);

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      if (!isDeleteVisible) {
                        Get.to(() => PaidCourseContentList(
                          appbarTitle: course.title ?? '',
                          courseId: course.id.toString(),
                        ));
                        controller.getPaidCourseContent(course.id.toString());
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        if (isDeleteVisible) {
                          _showDelete.remove(index);
                        } else {
                          _showDelete.add(index);
                        }
                      });
                    },
                    tileColor: Get.theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading: Container(
                      height: 35,
                      width: 35,
                      color: Get.theme.scaffoldBackgroundColor,
                      child: Image.network(
                        course.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                      ),
                    ),
                    title: Poppins(
                      text: course.title ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    subtitle: Poppins(
                      text: "${course.contentsCount ?? 0} Topics",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Get.theme.hintColor,
                    ),
                    trailing: isDeleteVisible
                        ? IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await controller.deletePaidCourse(int.parse(course.id.toString()));
                        await _refreshCourses();
                        setState(() => _showDelete.remove(index));
                      },
                    )
                        : Icon(Icons.arrow_forward_ios, size: 20, color: Get.theme.secondaryHeaderColor),
                  ),
                  SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomButton(
            onPressed: () => Get.to(() => AddNewPaidCourse()),
            child: Poppins(
              text: 'Add New Course',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Get.theme.scaffoldBackgroundColor,
            ),
          ),
        ),
      );
    });
  }
}

