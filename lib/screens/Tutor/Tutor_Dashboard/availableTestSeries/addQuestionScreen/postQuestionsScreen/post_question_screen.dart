import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../customWidgets/customtext.dart';

class PostQuestionScreen extends StatefulWidget {
  final String testId;
  const PostQuestionScreen({super.key, required this.testId});

  @override
  State<PostQuestionScreen> createState() => _PostQuestionScreenState();
}

class _PostQuestionScreenState extends State<PostQuestionScreen> {
  bool isLoading = false; // To track loading state

  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<CourseController>().getMcqQuestions(widget.testId);
  }

  @override
  void dispose() {
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void _submitQuestion() async {
    final question = questionController.text.trim();
    final optionA = optionAController.text.trim();
    final optionB = optionBController.text.trim();
    final optionC = optionCController.text.trim();
    final optionD = optionDController.text.trim();
    final answer = answerController.text.trim();

    if (question.isEmpty ||
        optionA.isEmpty ||
        optionB.isEmpty ||
        optionC.isEmpty ||
        optionD.isEmpty ||
        answer.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    setState(() {
      isLoading = true; // Set loading to true while submitting the question
    });

    try {
      final response =
          await Get.find<CourseController>().postQuestionsAndAnswers(
        testSeriesId: int.parse(widget.testId),
        question: question,
        optionA: optionA,
        optionB: optionB,
        optionC: optionC,
        optionD: optionD,
        answer: answer,
      );

      if (response.status == 200) {
        Get.snackbar('Success', 'Question submitted successfully');
        Get.find<CourseController>().getMcqQuestions(widget.testId);

        // Clear fields after success
        questionController.clear();
        optionAController.clear();
        optionBController.clear();
        optionCController.clear();
        optionDController.clear();
        answerController.clear();
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to submit question: $error');
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after submission is done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: CustomButton(
          onPressed: _submitQuestion,
          child: Poppins(
            text: 'Submit',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ), // Disable button while loading
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
          text: 'Add Questions & Answers',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Get.theme.secondaryHeaderColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Poppins(
              text: 'Question',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter question',
              controller: questionController,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: 'Option A',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter Option A',
              controller: optionAController,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: 'Option B',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter Option B',
              controller: optionBController,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: 'Option C',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter Option C',
              controller: optionCController,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: 'Option D',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter Option D',
              controller: optionDController,
            ),
            const SizedBox(height: 12),
            Poppins(
              text: 'Answer',
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CustomTextField(
              hintText: 'Enter correct option',
              controller: answerController,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ), // Show loading indicator
              ),
          ],
        ),
      ),
    );
  }
}
