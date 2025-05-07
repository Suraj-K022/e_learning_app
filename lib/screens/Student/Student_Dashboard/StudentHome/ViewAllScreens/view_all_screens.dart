import 'package:e_learning_app/customWidgets/paidCourseCard.dart';
import 'package:e_learning_app/customWidgets/test_series_widget.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/AvailablePaidCourseScreen/available_paid_course_screen.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/CoursePreviewList/courseContent/course_content_screen.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/testSeriesScreen/test_series_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/CoursesScreen/CourseContentList/course_content_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/course_Controller.dart';
import '../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../customWidgets/course_card_widget.dart';
import '../../../../../customWidgets/customtext.dart';
import '../../../../../customWidgets/pdf_card_widget.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/CoursePreviewList/course_preview_list.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';

class ViewAllScreens extends StatefulWidget {
  final String appbarTitle;

  const ViewAllScreens({super.key, required this.appbarTitle});

  @override
  State<ViewAllScreens> createState() => _ViewAllScreensState();
}

class _ViewAllScreensState extends State<ViewAllScreens> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<CourseController>();
      controller.getAllCourses();
      controller.getAllTestSeries();
    });

    _searchController.addListener(() {
      Get.find<CourseController>().filterCourses(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildLoading() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: Get.height / 3),
      Center(child: CircularProgressIndicator(color: Get.theme.primaryColor)),
    ],
  );

  Widget buildEmptyState(String message) => Center(
    child: Padding(
      padding: EdgeInsets.only(top: Get.height / 3),
      child: Poppins(
        text: message,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Get.theme.hintColor,
      ),
    ),
  );

  Widget buildGridView({
    required int count,
    required IndexedWidgetBuilder builder,
    int crossAxisCount = 2,
    double childAspectRatio = 1 / 1.1, // default aspect ratio
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: builder,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final isPdf = widget.appbarTitle == 'PDF Notes';
    final isCourse = widget.appbarTitle == 'Free Courses';
    final isPaidCourse = widget.appbarTitle == 'Paid Courses';
    final isTestSeries = widget.appbarTitle == 'Test Series';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: widget.appbarTitle,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor, size: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isPdf && !isTestSeries)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search...',
                  prefixIcon: Icons.search,
                ),
              ),
            GetBuilder<CourseController>(
              builder: (controller) {
                if (controller.isLoading) return buildLoading();

                if (isCourse ) {
                  if (controller.getCourseList.isEmpty) {
                    return buildEmptyState("No courses found.");
                  }

                  return buildGridView(
                    count: controller.getCourseList.length,
                    builder: (context, index) {
                      final course = controller.getCourseList[index];

                      // SAFELY get content if available
                      final contentList = controller.allContentList;
                      final content = (contentList != null && contentList.length > index)
                          ? contentList[index]
                          : null;

                      final pdfUrl = content?.pdfUpload ?? '';
                      final videoUrl = content?.vedioUpload ?? '';
                      final imgUrl = content?.contentImage ?? '';

                      return InkWell(
                        onTap: () {
                          Get.to(() => CoursePreviewList(
                            courseId: course.id.toString(),
                            title: course.courseName ?? '',
                            pdfUrl: pdfUrl.toString(),
                            videoUrl: videoUrl.toString(),
                            imgUrl: imgUrl,
                          ));
                        },
                        child: CourseCard(
                          title: course.courseName ?? '',
                          description: 'See Full Course',
                          count: course.contentsCount?.toString() ?? '0',
                          imageUrl: course.courseImage ?? '',
                        ),
                      );
                    },
                  );
                }

                if (isPdf) {
                  if (controller.getpdfNotes.isEmpty) {
                    return buildEmptyState("No PDFs found.");
                  }

                  return buildGridView(
                    count: controller.getpdfNotes.length,
                    builder: (context, index) {
                      final pdf = controller.getpdfNotes[index];

                      return InkWell(
                        onTap: () {
                          Get.to(() => PdfDetailScreen(
                            title: pdf.name ?? '',
                            description: 'View PDF',
                            pdfPath: pdf.pdfUrl ?? '',
                          ));
                        },
                        child: PdfCard(
                          title: pdf.name ?? '',
                          description: 'View PDF',
                          imgUrl: pdf.imageUrl ?? '',
                          // color: Get.theme.cardColor,
                        ),
                      );
                    },
                  );
                }
                if (isPaidCourse) {
                  return buildGridView(
                    count: 10,
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    builder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(()=>AvailablePaidCourseScreen(amount: '200',title: 'Python', courseId: '91', videoUrl: 'videoUrl', imgUrl: 'imgUrl', pdfUrl: 'pdfUrl'));
                        },
                        child: PaidCourseCard(),
                      );
                    },
                  );
                }



                if (isTestSeries) {
                  if (controller.allTestSeries.isEmpty) {
                    return buildEmptyState("No Test found.");
                  }

                  return buildGridView(
                    count: controller.allTestSeries.length,
                    builder: (context, index) {
                      final test = controller.allTestSeries[index];

                      return InkWell(
                        onTap: () {
                          Get.to(() => TestSeriesScreen(
                            appBarTitle: test.title.toString(),
                            testId: test.id.toString(),
                          ));
                        },
                        child: TestSeriesWidget(
                          title: test.title.toString(),
                          image: test.thumbnail.toString(),
                        ),
                      );
                    },
                  );
                }

                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
