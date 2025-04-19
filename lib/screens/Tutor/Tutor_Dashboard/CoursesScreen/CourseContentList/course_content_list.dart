import 'package:e_learning_app/controller/course_Controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../customWidgets/customtext.dart';
import '../../CreateNewCourses/create_new_course.dart';
import 'VideoPlayerScreen/video_player_screen.dart';

class CourseContentList extends StatefulWidget {
  final String appbarTitle;
  final String courseId;

  const CourseContentList({
    super.key,
    required this.courseId,
    required this.appbarTitle,
  });

  @override
  State<CourseContentList> createState() => _CourseContentListState();
}

class _CourseContentListState extends State<CourseContentList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllContent(widget.courseId);
    });
  }

  String sanitize(String? url) {
    if (url == null) return '';
    return url.replaceAll(RegExp(r'^\[|\]$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (courseController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                color: Get.theme.secondaryHeaderColor),
          ),
          title: Poppins(
            text: widget.appbarTitle,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => CreateNewCourse(
                    courseName: widget.appbarTitle,
                    ScreenName: 'CourseContentScreen'));
              },
              child:
                  Icon(CupertinoIcons.plus_app, color: Get.theme.primaryColor),
            ),
            const SizedBox(width: 24),
          ],
        ),
        body: (courseController.allContentList == null ||
                courseController.allContentList!.isEmpty)
            ? Center(
                child: Poppins(
                  text: 'No Lecture Found',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.secondaryHeaderColor,
                ),
              )
            : RefreshIndicator(
                color: Get.theme.scaffoldBackgroundColor,
                backgroundColor: Get.theme.primaryColor,
                onRefresh: () async {
                  await courseController.getAllContent(widget.courseId);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: courseController.allContentList!.length,
                  itemBuilder: (context, index) {
                    final content = courseController.allContentList![index];
                    final cleanPdfUrl = sanitize(content.pdfUpload.toString());
                    final cleanVideoUrl =
                        sanitize(content.vedioUpload.toString());

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Poppins(
                          text: '${index + 1} .',
                          color: Get.theme.secondaryHeaderColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        onTap: () {
                          print(cleanPdfUrl);
                          print(cleanVideoUrl);

                          Get.to(() => VideoPlayerScreen(
                                discription: content.description.toString(),
                                pdfName: content.title.toString(),
                                videoUrl: cleanVideoUrl,
                                pdfPath: cleanPdfUrl,
                              ));
                        },
                        trailing: InkWell(
                          onTap: () async {
                            Get.dialog(
                              Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            await Get.find<CourseController>()
                                .deleteContent(
                              courseController.allContentList![index]
                                  .id!, // <- assert non-null
                            )
                                .then((response) {
                              if (response.status == 200) {
                                Get.close(1);
                                courseController.getAllContent(widget.courseId);
                                courseController.getAllCourses();
                              } else {
                                Get.snackbar('Error', response.message);
                              }
                            });

                            Get.close(1); // Close the loading dialog
                          },
                          child: Icon(CupertinoIcons.delete,
                              size: 20, color: Colors.red),
                        ),
                        horizontalTitleGap: 0,
                        tileColor: Get.theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Poppins(
                          text: content.title ?? '',
                          fontWeight: FontWeight.w400,
                          color: Get.theme.secondaryHeaderColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
      );
    });
  }
}
