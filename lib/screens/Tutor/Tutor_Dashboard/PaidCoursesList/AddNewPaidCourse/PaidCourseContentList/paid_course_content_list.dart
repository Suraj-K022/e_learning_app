import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/PaidCoursesList/paid_courses_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../customWidgets/customtext.dart';
import '../../../CoursesScreen/CourseContentList/VideoPlayerScreen/video_player_screen.dart';
import '../addPaidCourseContent/add_paid_course_content.dart';

class PaidCourseContentList extends StatefulWidget {
  final String appbarTitle;
  final String courseId;

  const PaidCourseContentList({
    super.key,
    required this.courseId,
    required this.appbarTitle,
  });

  @override
  State<PaidCourseContentList> createState() => _PaidCourseContentListState();
}

class _PaidCourseContentListState extends State<PaidCourseContentList> {
  final courseController = Get.find<CourseController>();
  int? longPressedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseController.getPaidCourseContent(widget.courseId);
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
              Get.to(() => AddPaidCourseContent(
                courseId: widget.courseId,
                courseName: widget.appbarTitle,
              ));
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              controller.getMyPaidCourses();
              Get.off(PaidCoursesList());
            },
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
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.paidCourseContents.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Poppins(
                text: 'No lectures have been\nadded yet.',
                textAlign: TextAlign.center,
                fontSize: 16,
                maxLines: 2,
                fontWeight: FontWeight.w500,
                color: Get.theme.secondaryHeaderColor,
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            await controller.getPaidCourseContent(widget.courseId);
          },
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: controller.paidCourseContents.length,
            itemBuilder: (context, index) {
              final content = controller.paidCourseContents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(

                  onTap: () {
                    Get.to(() => VideoPlayerScreen(
                      videoUrl: content.videoUpload ?? '',
                      pdfPath: content.pdfUpload ?? '',
                      pdfName: content.title ?? 'Untitled',
                      discription:
                      content.description ?? 'No description',
                      imagePath: content.contentImage ?? '',
                    ));
                    print(content.videoUpload);
                  },
                  onLongPress: () {
                    setState(() {
                      longPressedIndex = index;
                    });
                    resetLongPress();
                  },
                  leading: Container(height: 40,width: 40,decoration: BoxDecoration(color: Get.theme.scaffoldBackgroundColor,borderRadius: BorderRadius.all(Radius.circular(4))),child: Image.network(content.contentImage.toString(),width: 40,height: 40,)),
                  // Poppins(
                  //   text: '${index + 1}.',
                  //   color: Get.theme.secondaryHeaderColor,
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.w500,
                  // ),
                  trailing: longPressedIndex == index
                      ? InkWell(
                    onTap: () async {
                      final response = await controller
                          .deletePaidCourseContent(
                          int.parse(
                              content.id.toString()));
                      if (response.status == 200) {
                        controller.getPaidCourseContent(
                            widget.courseId);
                        setState(() {
                          longPressedIndex = null;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                  )
                      : Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Get.theme.secondaryHeaderColor,
                  ),
             
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

