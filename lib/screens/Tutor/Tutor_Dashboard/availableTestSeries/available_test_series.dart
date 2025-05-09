import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AddTestScreen/add_test_screen.dart';
import 'addQuestionScreen/add_question_screen.dart';


class AvailableTestSeries extends StatefulWidget {
  const AvailableTestSeries({super.key});

  @override
  State<AvailableTestSeries> createState() => _AvailableTestSeriesState();
}

class _AvailableTestSeriesState extends State<AvailableTestSeries> {
  final CourseController _courseController = Get.find<CourseController>();
  final Set<int> _showDelete = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _courseController.getAllTestSeries();
    });
  }

  Future<void> _onRefresh() async {
    await _courseController.getAllTestSeries();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (controller) {
      final testSeries = controller.allTestSeries;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
            onPressed: () => Get.close(1),
          ),
          title: Poppins(
            text: 'Available Test Series',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: testSeries.isEmpty
              ?  Center(
              child: Center(child: Poppins(text: 'No Test Series found',fontWeight: FontWeight.w500,fontSize: 14,color: Get.theme.secondaryHeaderColor,))
          )
              : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: testSeries.length,
            itemBuilder: (context, index) {
              final test = testSeries[index];
              final isDeleteVisible = _showDelete.contains(index);
              final title = (test.title ?? '').trim().isEmpty ? 'Untitled' : test.title!;
              final id = test.id?.toString() ?? '';

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      if (!isDeleteVisible) {
                        Get.to(() => AddQuestionScreen(
                          testName: title,
                          testSeriesId: id,
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
                        test.thumbnail ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                      ),
                    ),
                    title: Poppins(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    subtitle: Poppins(
                      text: 'Test Series',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Get.theme.hintColor,
                    ),
                    trailing: isDeleteVisible
                        ? IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await controller.deleteTest(int.parse(test.id.toString()));
                        await _onRefresh();
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
            onPressed: () => Get.to(() => AddTestScreen()),
            child: Poppins(
              text: 'Add New Test',
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
