import 'dart:io';
import 'package:e_learning_app/customWidgets/Custom_input_text_field.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/availableTestSeries/available_test_series.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controller/course_Controller.dart';

class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final TextEditingController _testController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _thumbnailFile;
  String? _thumbnailPath;
  bool _isLoading = false;
  bool _thumbnailTooLarge = false;
  bool _testNameError = false;
  bool _thumbnailError = false;

  Future<void> _pickThumbnail() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 2 * 1024 * 1024) { // 2MB limit
        setState(() {
          _thumbnailTooLarge = true;
          _thumbnailFile = null;
          _thumbnailPath = null;
        });
        return;
      }

      setState(() {
        _thumbnailTooLarge = false;
        _thumbnailFile = file;
        _thumbnailPath = pickedFile.path;
      });
    }
  }

  void _saveTest() {
    final testName = _testController.text.trim();
    bool hasError = false;

    setState(() {
      _testNameError = testName.isEmpty;
      _thumbnailError = _thumbnailPath == null;
      hasError = _testNameError || _thumbnailError || _thumbnailTooLarge;
    });

    if (hasError) return;

    setState(() => _isLoading = true);

    Get.find<CourseController>().addTest(
      testName: testName,
      thumbnailImg: [_thumbnailPath!],
    ).then((response) {
      setState(() => _isLoading = false);

      if (response.status == 200) {
        Get.close(1);
        Get.find<CourseController>().getAllTestSeries();
      } else {
        Get.snackbar('Error', response.message);
      }
    }).catchError((error) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to add course: $error');
    });
  }

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Get.theme.primaryColor,
            color: Get.theme.scaffoldBackgroundColor,
          ),
        )
            : CustomButton(
          onPressed: _saveTest,
          child: Poppins(
            text: 'Add Test',
            color: Get.theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
            text: 'Test Name ',
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter Test Name',
            controller: _testController,
            errorText: _testNameError ? 'Test name is required' : null,
          ),
          const SizedBox(height: 20),
          Poppins(
            text: 'Add Thumbnail',
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickThumbnail,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Get.theme.hintColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Poppins(
                    text: 'Add Thumbnail',
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Get.theme.secondaryHeaderColor,
                  ),
                ],
              ),
            ),
          ),
          if (_thumbnailError && !_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Poppins(
                text: 'Thumbnail is required',
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          if (_thumbnailFile != null) ...[
            const SizedBox(height: 8),
            Poppins(
              text: 'Selected: ${_thumbnailFile!.path.split('/').last}',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(_thumbnailFile!, height: 160, fit: BoxFit.cover),
            ),
            if (_thumbnailTooLarge)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Poppins(
                  text: 'Image must be less than 2MB',
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
