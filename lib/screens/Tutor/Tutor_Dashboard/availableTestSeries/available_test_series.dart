import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addQuestionScreen/add_question_screen.dart';

class AvailableTestSeries extends StatefulWidget {
  const AvailableTestSeries({super.key});

  @override
  State<AvailableTestSeries> createState() => _AvailableTestSeriesState();
}

class _AvailableTestSeriesState extends State<AvailableTestSeries> {
  final CourseController _courseController = Get.find<CourseController>();

  @override
  void initState() {
    super.initState();
    _loadTestSeries();
  }

  void _loadTestSeries() {
    _courseController.getAllTestSeries();
  }

  Future<void> _onRefresh() async {
    await _courseController.getAllTestSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
          onPressed: () => Get.back(),
        ),
        title: Poppins(
          text: 'Available Test Series',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Get.theme.secondaryHeaderColor,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<CourseController>(
        builder: (controller) {
          final testSeries = controller.allTestSeries;

          if (testSeries.isEmpty) {
            return const Center(child: Text('No test series available.'));
          }

          return RefreshIndicator(
            backgroundColor: Get.theme.primaryColor,
            color: Get.theme.scaffoldBackgroundColor,
            onRefresh: _onRefresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: testSeries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final test = testSeries[index];
                final title = test.title?.trim().isNotEmpty == true
                    ? test.title!
                    : 'Untitled';
                final id = test.id?.toString() ?? '';

                return ListTile(
                  tileColor: Get.theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: Poppins(
                    text: '${index + 1}',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.hintColor,
                  ),
                  title: Poppins(
                    text: title,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  onTap: () {
                    Get.to(() => AddQuestionScreen(
                          testName: title,
                          testSeriesId: id,
                        ));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
