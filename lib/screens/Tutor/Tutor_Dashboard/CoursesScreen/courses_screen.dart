import 'package:e_learning_app/controller/course_Controller.dart';
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
    Get.find<CourseController>().getAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Get.to(AddCourseNameScreen());
            },
            child: Icon(
              CupertinoIcons.plus_app,
              color: Get.theme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 24),
        ],
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Courses',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () {
            Get.back(canPop: true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: GetBuilder<CourseController>(builder: (courseController) {
        return RefreshIndicator(
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          onRefresh: () async {
            await courseController.getAllCourses();
          },
          child: (courseController.getCourseList.isEmpty)
              ? ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: Get.height / 3),
                    Center(
                      child: Poppins(
                        text: 'No Courses Found',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: courseController.getCourseList.length,
                  itemBuilder: (context, index) {
                    final course = courseController.getCourseList[index];
                    final isDeleteVisible = _showDelete.contains(index);

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (!isDeleteVisible) {
                              Get.to(() => CourseContentList(
                                    appbarTitle: course.courseName.toString(),
                                    courseId: course.id.toString(),
                                  ));
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              if (_showDelete.contains(index)) {
                                _showDelete.remove(index);
                              } else {
                                _showDelete.add(index);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Get.theme.cardColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.network(
                                          course.courseImage.toString()),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Poppins(
                                          text: course.courseName.toString(),
                                          fontWeight: FontWeight.w400,
                                          color: Get.theme.secondaryHeaderColor,
                                          fontSize: 14,
                                        ),
                                        Poppins(
                                          text:
                                              '${course.totalContent} lectures',
                                          fontWeight: FontWeight.w400,
                                          color: Get.theme.hintColor,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                isDeleteVisible
                                    ? IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          // await courseController.deleteCourse(course.id); // Make sure you have this method
                                          await courseController
                                              .getAllCourses(); // Refresh after deletion
                                          setState(() {
                                            _showDelete.remove(index);
                                          });
                                        },
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: Get.theme.secondaryHeaderColor,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  },
                ),
        );
      }),
    );
  }
}
