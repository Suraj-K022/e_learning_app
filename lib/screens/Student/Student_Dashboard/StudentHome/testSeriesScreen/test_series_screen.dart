import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';

import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/model/response/mcqModel.dart';

class TestSeriesScreen extends StatefulWidget {
  final String testId;
  final String appBarTitle;
  const TestSeriesScreen({super.key, required this.testId, required this.appBarTitle});

  @override
  State<TestSeriesScreen> createState() => _TestSeriesScreenState();
}

class _TestSeriesScreenState extends State<TestSeriesScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  final List<int?> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getMcqQuestions(widget.testId);
    });
  }

  void nextQuestion() {
    final controller = Get.find<CourseController>();
    final questions = controller.getQuestions;

    if (selectedOptions.length != questions.length) {
      selectedOptions.clear();
      selectedOptions.addAll(List.filled(questions.length, null));
    }

    if (selectedOptions[currentIndex] == null) {
      Get.snackbar("Please select an option", "You need to choose one.");
      return;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // ✅ Corrected score calculation
      int score = 0;
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        final selected = selectedOptions[i];

        final correctIndex = switch (q.correctOption?.toLowerCase()) {
          'a' => 0,
          'b' => 1,
          'c' => 2,
          'd' => 3,
          _ => -1,
        };

        if (selected != null && selected == correctIndex) {
          score++;
        }
      }

      // 🎉 Show result dialog
      Get.defaultDialog(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: "Test Completed",
        content: Column(
          children: [
            Poppins(
              text: "You scored $score out of ${questions.length}",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Get.theme.secondaryHeaderColor,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                Get.back();
                Get.to(() => TestResultScreen(
                      questions: questions,
                      selectedOptions: selectedOptions,
                    ));
              },
              child: Poppins(
                text: "Show Answers",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Get.theme.scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
        radius: 10,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          GetBuilder<CourseController>(
            builder: (controller) {
              final totalQuestions = controller.getQuestions.length;
              return Row(
                children: [
                  Poppins(
                    text: '${currentIndex + 1} / $totalQuestions',
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  const SizedBox(width: 24),
                ],
              );
            },
          )
        ],

        title: Poppins(
          text: widget.appBarTitle,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Get.theme.secondaryHeaderColor,
        ),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.bottomSheet(
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Poppins(
                      text: "Are you sure you want to exit the test?",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => Get.back(),
                            child: Poppins(
                              text: "Cancel",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Get.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              Get.back();
                              Get.back();
                            },
                            child: Poppins(
                              text: "Exit",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Get.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          child: Icon(Icons.arrow_back_ios,
              size: 24, color: Get.theme.secondaryHeaderColor),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          onPressed: nextQuestion,
          child: Poppins(
            text: "Next",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.scaffoldBackgroundColor,
          ),
        ),
      ),
      body: GetBuilder<CourseController>(
        builder: (controller) {
          final questions = controller.getQuestions;
          if (questions.isEmpty) {
            return Center(
                child: Poppins(
              text: 'No Questions Available',
              color: Get.theme.hintColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ));
          }

          if (selectedOptions.length != questions.length) {
            selectedOptions.clear();
            selectedOptions.addAll(List.filled(questions.length, null));
          }

          return PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final options = [q.optionA, q.optionB, q.optionC, q.optionD];
              final selected = selectedOptions[index];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(
                      text: "Q${index + 1}:  ${q.questionText ?? ''}",
                      maxLines: 10,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(options.length, (optIndex) {
                      final optionText = options[optIndex] ?? '';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOptions[index] = optIndex;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Get.theme.cardColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected == optIndex
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: Get.theme.secondaryHeaderColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Poppins(
                                  text: optionText,
                                  fontSize: 14,
                                  maxLines: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Get.theme.secondaryHeaderColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}












class TestResultScreen extends StatelessWidget {
  final List<McqModel> questions;
  final List<int?> selectedOptions;

  const TestResultScreen({
    super.key,
    required this.questions,
    required this.selectedOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child:
              Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
        ),
        title: Poppins(
          text: "Answer Review",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Get.theme.secondaryHeaderColor,
        ),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final options = [
            q.optionA ?? '',
            q.optionB ?? '',
            q.optionC ?? '',
            q.optionD ?? ''
          ];
          final selected = selectedOptions[index];

          final correctIndex = switch (q.correctOption?.toLowerCase()) {
            'a' => 0,
            'b' => 1,
            'c' => 2,
            'd' => 3,
            _ => -1,
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Poppins(
                  text: "Q${index + 1}: ${q.questionText ?? ''}",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  maxLines: 10,
                  color: Get.theme.secondaryHeaderColor,
                ),
                const SizedBox(height: 12),
                ...List.generate(options.length, (optIndex) {
                  final option = options[optIndex];
                  final isCorrect = correctIndex == optIndex;
                  final isSelected = selected == optIndex;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? Colors.green.withOpacity(0.2)
                          : isSelected
                              ? Colors.red.withOpacity(0.2)
                              : Colors.transparent,
                      border: Border.all(
                        color: isCorrect
                            ? Colors.green
                            : isSelected
                                ? Colors.red
                                : Get.theme.cardColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle
                              : isSelected
                                  ? Icons.cancel
                                  : Icons.circle_outlined,
                          color: isCorrect
                              ? Colors.green
                              : isSelected
                                  ? Colors.red
                                  : Get.theme.secondaryHeaderColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Poppins(
                            text: option,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onPressed: () {
            Get.close(2);
          },
          child: Poppins(
            text: "Finish",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
