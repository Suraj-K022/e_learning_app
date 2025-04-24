import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/availableTestSeries/addQuestionScreen/postQuestionsScreen/post_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../CustomWidgets/custom_snackbar.dart';
import '../../../../../customWidgets/customtext.dart';

class AddQuestionScreen extends StatefulWidget {
  final String testSeriesId;
  final String testName;

  const AddQuestionScreen({
    super.key,
    required this.testSeriesId,
    required this.testName,
  });

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final CourseController _courseController = Get.find<CourseController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestions();
    });
  }

  void _loadQuestions() {
    _courseController.getMcqQuestions(widget.testSeriesId);
  }

  Future<void> _onRefresh() async {
    await _courseController.getMcqQuestions(widget.testSeriesId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: CustomButton(
          child: Poppins(
            text: 'Add More Questions',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.scaffoldBackgroundColor,
          ),
          onPressed: () async {
            await Get.to(PostQuestionScreen(testId: widget.testSeriesId));
            _loadQuestions(); // refresh on return
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: Poppins(
          text: widget.testName,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Get.theme.secondaryHeaderColor,
        ),
      ),
      body: GetBuilder<CourseController>(
        builder: (controller) {
          final questions = controller.getQuestions;

          if (questions.isEmpty) {
            return Center(
                child: Poppins(
              text: 'No Questions Available',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
            ));
          }

          return RefreshIndicator(
            backgroundColor: Get.theme.primaryColor,
            color: Get.theme.scaffoldBackgroundColor,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: questions.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Poppins(
                          text: 'Q${index + 1}: ${question.questionText}',
                          fontWeight: FontWeight.w600,
                          maxLines: 10,
                          fontSize: 15,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                        const SizedBox(height: 10),
                        Poppins(
                          text: 'A. ${question.optionA}',
                          maxLines: 10,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                        Poppins(
                          maxLines: 10,
                          text: 'B. ${question.optionB}',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                        Poppins(
                          maxLines: 10,
                          text: 'C. ${question.optionC}',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                        Poppins(
                          maxLines: 10,
                          text: 'D. ${question.optionD}',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Poppins(
                              text: 'Correct Answer: ${question.correctOption}',
                              maxLines: 10,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.green,
                            ),
                            InkWell(
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    title: Poppins(
                                      text: "Confirm Deletion",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Get.theme.secondaryHeaderColor,
                                    ),
                                    content: Poppins(
                                      text:
                                          "Are you sure you want to delete this question?",
                                      maxLines: 3,
                                      color: Get.theme.secondaryHeaderColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                        child: Text("No",
                                            style: TextStyle(
                                                color: Get
                                                    .theme.secondaryHeaderColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final questionId = int.tryParse(
                                              controller.getQuestions[index].id
                                                  .toString());

                                          if (questionId == null) {
                                            Get.back();
                                            showCustomSnackBar(
                                                "Invalid question ID",
                                                isError: true);
                                            return;
                                          }

                                          final result =
                                              await Get.find<CourseController>()
                                                  .deleteQuestion(questionId);

                                          if (result.status == 200) {
                                            Get.close(1); // Close dialog first
                                            _loadQuestions(); // Refresh the list
                                            showCustomSnackBar(
                                                "Question deleted successfully",
                                                isError: false);
                                          } else {
                                            showCustomSnackBar(result.message,
                                                isError: true);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Get.theme.canvasColor,
                                        ),
                                        child: Poppins(
                                          text: "Yes",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color:
                                              Get.theme.scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(Icons.delete_forever,
                                  color: Get.theme.canvasColor, size: 20),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
