import 'dart:io';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../customWidgets/custom_check_box.dart';
import '../../../../../../customWidgets/customtext.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  File? _image;
  List<String> _selectedProblems = [];
  final TextEditingController descriptionController = TextEditingController();

  Map<String, bool> _checkboxValues = {
    "Lectures": false,
    "Images": false,
    "Pdfs": false,
    "Doubts": false,
    "Others": false,
  };

  bool _isLoading = false;  // Variable to track loading state

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileSize = await pickedFile.length();
      if (fileSize > 3 * 1024 * 1024) {
        Get.snackbar("Error", "Image size exceeds 3MB limit",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void submitReport() {
    setState(() {
      _isLoading = true; // Set loading state to true when submitting
    });

    // Get selected problems (checkbox values)
    _selectedProblems = _checkboxValues.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Ensure that at least one problem is selected
    if (_selectedProblems.isEmpty) {
      setState(() {
        _isLoading = false; // Reset loading state
      });
      Get.snackbar("Required", "Please select at least one problem area.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final String description = descriptionController.text.trim();
    final String? imagePath = _image?.path;

    // Print selected data for debugging
    print("✅ Selected Problems: $_selectedProblems");
    print("📝 Description: $description");
    print("🖼️ Image Path: ${imagePath ?? 'No image selected'}");

    // Prepare the report submission
    Get.find<CourseController>().reportProblem(
      type: _selectedProblems.join(','), // Join the list elements into a comma-separated string
      description: description,
      image: File(imagePath.toString()), // Only create File if imagePath is not null
    ).then((response) {
      setState(() {
        _isLoading = false; // Reset loading state after submission
      });

      if (response.status == 200) {
        Get.close(1);
      } else {
        Get.snackbar('Error', response.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          child: _isLoading
              ? SizedBox(height: 24,width: 24,
                child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                  Get.theme.scaffoldBackgroundColor),
                          ),
              )
              : Poppins(
            text: 'Submit',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.scaffoldBackgroundColor,
          ),
          onPressed: _isLoading ? null : submitReport, // Disable button while loading
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Report a Problem',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios,
              color: Get.theme.secondaryHeaderColor, size: 24),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
            text: 'What are you facing problem with?',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Get.theme.hintColor,
          ),
          SizedBox(height: 10),
          Column(
            children: _checkboxValues.keys
                .map((label) => _buildCheckBoxItem(label))
                .toList(),
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: descriptionController,
            hintText: 'Please describe the problem you faced',
            maxLines: 10,
          ),
          SizedBox(height: 20),
          Poppins(
            text: 'Supporting screenshot (optional)',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Get.theme.hintColor,
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: Get.theme.secondaryHeaderColor, width: 1),
              ),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image != null)
                    Stack(
                      children: [
                        Image.file(_image!,
                            height: 100, width: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _image = null),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo,
                            color: Get.theme.secondaryHeaderColor, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Upload image up to Max 3 MB',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Get.theme.secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxItem(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CustomCheckBox(
            onChanged: (value) {
              setState(() {
                _checkboxValues[label] = value!;
              });
            },
            value: _checkboxValues[label]!,
          ),
          SizedBox(width: 10),
          Poppins(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
        ],
      ),
    );
  }
}

