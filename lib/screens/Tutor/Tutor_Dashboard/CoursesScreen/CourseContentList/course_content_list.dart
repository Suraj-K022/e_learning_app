import 'package:e_learning_app/controller/course_Controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../customWidgets/custom_buttons.dart';
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
  final courseController = Get.find<CourseController>();
  int? longPressedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseController.getAllContent(widget.courseId);
    });
  }

  void resetLongPress() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          longPressedIndex = null;
        });
      }
    });
  }

  String sanitize(String? url) {
    if (url == null) return '';
    return url.replaceAll(RegExp(r'^\[|\]$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            child: Poppins(
              text: 'Add Course Contents',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Get.theme.scaffoldBackgroundColor,
            ),
            onPressed: () {
              Get.to(() => CreateNewCourse(
                  courseName: widget.appbarTitle,
                  courseId: widget.courseId));
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: InkWell(
            onTap: () => Get.close(1),
            child: Icon(Icons.arrow_back_ios,
                color: Get.theme.secondaryHeaderColor),
          ),
          title: Poppins(
            text: widget.appbarTitle,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        body: controller.allContentList == null ||
            controller.allContentList!.isEmpty
            ? Center(
          child: Poppins(
            text: 'No lectures have been\nadded yet.',
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            await controller.getAllContent(widget.courseId);
          },
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: controller.allContentList!.length,
            itemBuilder: (context, index) {
              final content = controller.allContentList![index];
              final videoUrl = sanitize(content.vedioUpload.toString());
              final pdfUrl = sanitize(content.pdfUpload.toString());
              final imageUrl = sanitize(content.contentImage);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    Get.to(() => VideoPlayerScreen(
                      videoUrl: videoUrl,
                      pdfPath: pdfUrl,
                      pdfName: content.title ?? 'Untitled',
                      discription: content.description ?? '',
                      imagePath: imageUrl,
                    ));
                  },
                  onLongPress: () {
                    setState(() {
                      longPressedIndex = index;
                    });
                    resetLongPress();
                  },
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Get.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                  trailing: longPressedIndex == index
                      ? InkWell(
                    onTap: () async {
                      Get.dialog(
                        Center(
                            child: CircularProgressIndicator(
                                color: Get.theme.primaryColor)),
                        barrierDismissible: false,
                      );

                      final response = await controller
                          .deleteContent(content.id!);
                      Get.close(1);

                      if (response.status == 200) {
                        controller.getAllContent(widget.courseId);
                        controller.getAllCourses();
                        setState(() {
                          longPressedIndex = null;
                        });
                      } else {
                        Get.snackbar('Error', response.message);
                      }
                    },
                    child: const Icon(Icons.delete,
                        size: 20, color: Colors.red),
                  )
                      : Icon(Icons.arrow_forward_ios,
                      size: 16,
                      color: Get.theme.secondaryHeaderColor),
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

