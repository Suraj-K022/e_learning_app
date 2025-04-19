import 'dart:async';

import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/customWidgets/test_series_widget.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/testSeriesScreen/test_series_screen.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../controller/course_Controller.dart';
import '../../../../customWidgets/course_card_widget.dart';
import '../../../../customWidgets/customtext.dart';
import '../../../../customWidgets/pdf_card_widget.dart';
import '../StudentProfile/SettingScreen/ProfileScreen/profile_screen.dart';
import 'CoursePreviewList/course_preview_list.dart';
import 'NotificationScreen/notification_screen.dart';
import 'PdfDetailScreen/pdf_detail_screen.dart';
import 'ViewAllScreens/view_all_screens.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseController = Get.find<CourseController>();
      courseController.getBanner();
      courseController.getPdfNotes();
      courseController.getAllCourses();
      courseController.getAllTestSeries();
      Get.find<AuthController>().getProfile();

      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        final bannerList = courseController.getBannerList;
        if (bannerList.isNotEmpty && _pageController.hasClients) {
          setState(() {
            _currentPage = (_currentPage + 1) % bannerList.length;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: GetBuilder<AuthController>(
          builder: (authController) {
            final profile = authController.profileModel;
            if (profile == null) {
              return CircularProgressIndicator(color: Get.theme.primaryColor);
            }
            return Row(
              children: [
                InkWell(
                  onTap: () => Get.to(ProfileScreen()),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        profile.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.person, size: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Poppins(
                  text: 'Hey, ${profile.username ?? ''}',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.primaryColor,
                )
              ],
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(NotificationScreen()),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 24,
              color: Get.theme.secondaryHeaderColor,
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
      body: GetBuilder<CourseController>(builder: (courseController) {
        return RefreshIndicator(
          backgroundColor: Get.theme.primaryColor,
          color: Get.theme.scaffoldBackgroundColor,
          onRefresh: () async {
            await courseController.getAllCourses();
            await courseController.getBanner();
            await courseController.getPdfNotes();
            await courseController.getAllTestSeries();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Divider(),
              const SizedBox(height: 10),

              // Banner Carousel
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: courseController.getBannerList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          double? page = _pageController.hasClients
                              ? _pageController.page
                              : null;

                          if (page != null) {
                            value = (1 - ((page - index).abs() * 0.4))
                                .clamp(0.8, 1.0);
                          }
                        }

                        return Center(
                          child: Transform.scale(
                            scale: Curves.easeOut.transform(value),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  courseController.getBannerList[index],
                                  fit: BoxFit.cover,
                                  // errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 80),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),
              Divider(),
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: courseController.getBannerList.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blue,
                  ),
                  onDotClicked: (index) {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              buildSectionHeader('Courses', 'Courses'),
              buildCourseGrid(courseController),
              SizedBox(height: 20),
              buildSectionHeader('Trending', 'Trending'),
              buildCourseGrid(courseController),
              SizedBox(height: 20),
              buildSectionHeader('PDF Notes', 'PDF NOTES'),
              SizedBox(
                height: 20,
              ),

              buildHorizontalPdfGrid(courseController),
              SizedBox(height: 20),
              buildSectionHeader('Test Series', 'Test Series'),
              SizedBox(height: 10),
              buildHorizontalTestSeriesGrid(courseController),
            ],
          ),
        );
      }),
    );
  }

  Widget buildSectionHeader(String title, String routeTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Poppins(
          text: title,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
          fontSize: 16,
        ),
        InkWell(
          onTap: () => Get.to(() => ViewAllScreens(appbarTitle: routeTitle)),
          child: Poppins(
            text: 'View All',
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
            fontSize: 12,
            textDecoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget buildCourseGrid(CourseController courseController) {
    final courseList = courseController.getCourseList;

    if (courseList.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: Get.theme.primaryColor,
      ));
    }

    int itemCount = courseList.length >= 4
        ? 4
        : courseList.length >= 2
            ? 2
            : courseList.length == 1
                ? 1
                : 0;

    // Determine screen width and calculate crossAxisCount dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    int crossAxisCount = isLandscape
        ? (screenWidth ~/ 220).clamp(2, 4)
        : 2; // Show more columns in landscape

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1 / 1.1,
      ),
      itemBuilder: (context, index) {
        final course = courseController.getCourseList[index];

        final hasContent = courseController.allContentList != null &&
            courseController.allContentList!.length > index;

        final pdfUrl = hasContent
            ? courseController.allContentList![index].pdfUpload?.toString() ??
                ''
            : '';
        final imgUrl = hasContent
            ? courseController.allContentList![index].contentImage
                    ?.toString() ??
                ''
            : '';
        final videoUrl = hasContent
            ? courseController.allContentList![index].vedioUpload?.toString() ??
                ''
            : '';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Get.to(CoursePreviewList(
                pdfUrl: pdfUrl,
                courseId: course.id.toString(),
                title: course.courseName.toString(),
                videoUrl: videoUrl,
                imgUrl: imgUrl,
              ));
            },
            child: CourseCard(
              count: course.totalContent.toString(),
              title: course.courseName.toString(),
              description: 'See Full Course',
              imageUrl: course.courseImage.toString(),
            ),
          ),
        );
      },
    );
  }

  Widget buildHorizontalPdfGrid(CourseController courseController) {
    if (courseController.getpdfNotes.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: Get.theme.primaryColor,
      ));
    }
    return SizedBox(
      height: 180,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.1,
        ),
        itemCount: courseController.getpdfNotes.length,
        itemBuilder: (context, index) {
          final note = courseController.getpdfNotes[index];
          return InkWell(
            onTap: () => Get.to(PdfDetailScreen(
              title: note.name ?? 'Untitled',
              description: 'View PDF',
              pdfPath: note.pdfUrl ?? '',
            )),
            child: PdfCard(
              imgUrl: note.imageUrl ?? '',
              title: note.name ?? '',
              description: 'View PDF',
              color: Get.theme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget buildHorizontalTestSeriesGrid(CourseController courseController) {
    if (courseController.allTestSeries.isEmpty) {
      return Center(
          child: CircularProgressIndicator(
        color: Get.theme.primaryColor,
      ));
    }

    return SizedBox(
      height: 180,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.1,
        ),
        itemCount: courseController.allTestSeries.length,
        itemBuilder: (context, index) {
          final test = courseController.allTestSeries[index];
          return InkWell(
            onTap: () => Get.to(TestSeriesScreen(
              testId: courseController.allTestSeries[index].id.toString(),
            )),
            child: TestSeriesWidget(
              title: test.title.toString(),
              image: test.thumbnail.toString(),
            ),
          );
        },
      ),
    );
  }
}
