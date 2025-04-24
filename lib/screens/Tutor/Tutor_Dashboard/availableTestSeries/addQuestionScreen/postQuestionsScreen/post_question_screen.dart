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
  bool isLoading = false;

  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  String? questionError;
  String? optionAError;
  String? optionBError;
  String? optionCError;
  String? optionDError;
  String? answerError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CourseController>().getMcqQuestions(widget.testId);

    },);
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
    setState(() {
      questionError = questionController.text.trim().isEmpty ? 'Required' : null;
      optionAError = optionAController.text.trim().isEmpty ? 'Required' : null;
      optionBError = optionBController.text.trim().isEmpty ? 'Required' : null;
      optionCError = optionCController.text.trim().isEmpty ? 'Required' : null;
      optionDError = optionDController.text.trim().isEmpty ? 'Required' : null;
      answerError = answerController.text.trim().isEmpty ? 'Required' : null;
    });

    if ([questionError, optionAError, optionBError, optionCError, optionDError, answerError].any((e) => e != null)) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Get.find<CourseController>().postQuestionsAndAnswers(
        testSeriesId: int.parse(widget.testId),
        question: questionController.text.trim(),
        optionA: optionAController.text.trim(),
        optionB: optionBController.text.trim(),
        optionC: optionCController.text.trim(),
        optionD: optionDController.text.trim(),
        answer: answerController.text.trim(),
      );

      if (response.status == 200) {
        Get.snackbar('Success', 'Question submitted successfully');
        Get.find<CourseController>().getMcqQuestions(widget.testId);

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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: CustomButton(
          onPressed: _submitQuestion,
          child: Poppins(
            text: 'Submit',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.scaffoldBackgroundColor,
          ),
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
            _buildField('Question', 'Enter question', questionController, questionError),
            _buildField('Option A', 'Enter Option A', optionAController, optionAError),
            _buildField('Option B', 'Enter Option B', optionBController, optionBError),
            _buildField('Option C', 'Enter Option C', optionCController, optionCError),
            _buildField('Option D', 'Enter Option D', optionDController, optionDError),
            _buildField('Answer(option)', 'Enter correct option', answerController, answerError),
            const SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Poppins(
          text: label,
          fontWeight: FontWeight.w500,
          color: Get.theme.hintColor,
          fontSize: 14,
        ),
        SizedBox(height: 4),
        CustomTextField(
          hintText: hint,
          controller: controller,
          errorText: errorText,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
