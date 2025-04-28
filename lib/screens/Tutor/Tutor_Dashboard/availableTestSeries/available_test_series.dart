import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddTestScreen/add_test_screen.dart';
import 'package:flutter/cupertino.dart';
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
  final Set<int> _showDelete = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _courseController.getAllTestSeries();

    },)
;  }

  Future<void> _onRefresh() async {
    await _courseController.getAllTestSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
          onPressed: () => Get.back(),
        ),
        title: Poppins(
          text: 'Available Test Series',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Get.theme.secondaryHeaderColor,
        ),

      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(24),child:
        CustomButton(child: Poppins(text: 'Add Test',fontWeight: FontWeight.w500,color: Get.theme.scaffoldBackgroundColor,fontSize: 16,), onPressed: (){
          Get.to(()=>AddTestScreen());

        }),),
      body: GetBuilder<CourseController>(builder: (controller) {
        final testSeries = controller.allTestSeries;

        return RefreshIndicator(
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          onRefresh: _onRefresh,
          child: (testSeries.isEmpty)
              ? ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: Get.height / 3),
              Center(
                child: Poppins(
                  text: 'No Test Series Found',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.secondaryHeaderColor,
                ),
              )
            ],
          )
              : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: testSeries.length,
            itemBuilder: (context, index) {
              final test = testSeries[index];
              final isDeleteVisible = _showDelete.contains(index);
              final title = test.title?.trim().isNotEmpty == true ? test.title! : 'Untitled';
              final id = test.id?.toString() ?? '';

              return Column(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (_showDelete.contains(index)) {
                          _showDelete.remove(index);
                        } else {
                          _showDelete.add(index);
                        }
                      });
                    },
                    child: ListTile(
                      tileColor: Get.theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Get.theme.secondaryHeaderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Get.theme.secondaryHeaderColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: isDeleteVisible
                          ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () async {
                          await controller.deleteTest(int.parse(_courseController.allTestSeries[index].id.toString()));
                          await _onRefresh();
                          setState(() {
                            _showDelete.remove(index);
                          });
                        },
                      )
                          : Icon(Icons.arrow_forward_ios, size: 20, color: Get.theme.secondaryHeaderColor),
                      onTap: () {
                        if (!isDeleteVisible) {
                          Get.to(() => AddQuestionScreen(
                            testName: title,
                            testSeriesId: id,
                          ));
                        }
                      },
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
