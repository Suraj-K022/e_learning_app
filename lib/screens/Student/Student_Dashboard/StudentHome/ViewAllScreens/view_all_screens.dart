import 'package:e_learning_app/customWidgets/test_series_widget.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/testSeriesScreen/test_series_screen.dart';
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
    // Fetch courses when screen is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllCourses();
      Get.find<CourseController>().getAllTestSeries();
    });

    // Listen to search input
    _searchController.addListener(() {
      Get.find<CourseController>().filterCourses(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show loading indicator
  Widget buildLoading() => Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: Get.height/3,),
      Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    ],
  );

  // Show message when nothing found
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

  // Grid view builder
  Widget buildGridView({required int count, required IndexedWidgetBuilder builder}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1 / 1.1,
        ),
        itemBuilder: builder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = widget.appbarTitle == 'PDF NOTES';
    final isCourse = widget.appbarTitle == 'Courses';
    final isTrending = widget.appbarTitle == 'Trending';
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
        leading: InkWell(onTap: ()=>Get.back(),child: Icon(Icons.arrow_back_ios,color: Get.theme.secondaryHeaderColor,size: 24,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Show search only if it's not PDF
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

                // Show Courses or Trending
                if (isCourse || isTrending) {
                  if (controller.getCourseList.isEmpty) {
                    return buildEmptyState("No courses found.");
                  }

                  return buildGridView(
                    count: controller.getCourseList.length,
                    builder: (context, index) {
                      final course = controller.getCourseList[index];
                      final contentList = controller.allContentList;

                      return InkWell(
                        onTap: () {
                          final pdfUrl = contentList?[index].pdfUpload ?? '';
                          final videoUrl = contentList?[index].vedioUpload ?? '';
                          final imgUrl = contentList?[index].contentImage ?? '';

                          Get.to(CoursePreviewList(
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
                          count: course.totalContent.toString(),
                          imageUrl: course.courseImage ?? '',
                        ),
                      );
                    },
                  );
                }

                // Show PDFs or Test Series
                if (isPdf ) {
                  if (controller.getpdfNotes.isEmpty) {
                    return buildEmptyState("No PDFs found.");
                  }

                  return buildGridView(
                    count: controller.getpdfNotes.length,
                    builder: (context, index) {
                      final pdf = controller.getpdfNotes[index];

                      return InkWell(
                        onTap: () {
                          Get.to(PdfDetailScreen(
                            title: pdf.name ?? '',
                            description: 'View PDF',
                            pdfPath: pdf.pdfUrl ?? '',
                          ));
                        },
                        child: PdfCard(
                          title: pdf.name ?? '',
                          description: 'View PDF',
                          imgUrl: pdf.imageUrl ?? '',
                          color: Get.theme.cardColor,
                        ),
                      );
                    },
                  );
                }  // Show  Test Series
                if ( isTestSeries) {
                  if (controller.allTestSeries.isEmpty) {
                    return buildEmptyState("No Test found.");
                  }

                  return buildGridView(
                    count: controller.allTestSeries.length,
                    builder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(TestSeriesScreen(

                          ));
                        },
                        child: TestSeriesWidget(title: controller.allTestSeries[index].title.toString(),image: controller.allTestSeries[index].imageUrl.toString(),),
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
