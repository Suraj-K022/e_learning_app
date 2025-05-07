import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../customWidgets/customtext.dart';
import 'AddCourseNameScreen/add_course_name_screen.dart';
import 'CourseContentList/course_content_list.dart';



class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final Set<int> _showDelete = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllCourses();
    });
  }

  Future<void> _refreshCourses() async {
    await Get.find<CourseController>().getAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          title: Poppins(
            text: 'Free Courses',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
            onPressed: () => Get.close(1),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshCourses,
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: controller.getCourseList.isEmpty
              ? Center(child: Poppins(text: 'No Course found',fontWeight: FontWeight.w500,fontSize: 14,color: Get.theme.secondaryHeaderColor,))
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.getCourseList.length,
            itemBuilder: (context, index) {
              final course = controller.getCourseList[index];
              final isDeleteVisible = _showDelete.contains(index);

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      if (!isDeleteVisible) {
                        Get.to(() => CourseContentList(
                          appbarTitle: course.courseName ?? '',
                          courseId: course.id.toString(),
                        ));
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
                        course.courseImage ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                      ),
                    ),
                    title: Poppins(
                      text: course.courseName ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    subtitle: Poppins(
                      text: "${course.contentsCount ?? 0} Lectures",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Get.theme.hintColor,
                    ),
                    trailing: isDeleteVisible
                        ? IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await controller.deleteCourse(int.parse(course.id.toString()));
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
            onPressed: () => Get.to(() => AddCourseNameScreen()),
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

