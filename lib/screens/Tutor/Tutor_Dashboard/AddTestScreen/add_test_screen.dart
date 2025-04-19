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

  Future<void> _pickThumbnail() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
        _thumbnailPath = pickedFile.path;
      });
    }
  }

  void _saveTest() {
    final testName = _testController.text.trim();

    if (testName.isEmpty || _thumbnailPath == null) {
      Get.snackbar('Error', 'Please provide course name and thumbnail');
      return;
    }

    Get.find<CourseController>().addTest(
        testName: testName, thumbnailImg: [_thumbnailPath!]).then((response) {
      if (response.status == 200) {
        Get.to(AvailableTestSeries());
      } else {
        Get.snackbar('Error', response.message);
      }
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to add course: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onPressed: _saveTest,
          child: Poppins(
            text: 'Add Test',
            color: Get.theme.secondaryHeaderColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new,
              size: 24, color: Get.theme.secondaryHeaderColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
              text: 'Test Name ',
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor),
          const SizedBox(height: 8),
          CustomTextField(
              hintText: 'Enter Test Name', controller: _testController),
          const SizedBox(height: 20),
          Poppins(
              text: 'Add Thumbnail',
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor),
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
                  Icon(Icons.arrow_forward_ios,
                      size: 20, color: Get.theme.secondaryHeaderColor),
                ],
              ),
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
              child:
                  Image.file(_thumbnailFile!, height: 160, fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }
}
