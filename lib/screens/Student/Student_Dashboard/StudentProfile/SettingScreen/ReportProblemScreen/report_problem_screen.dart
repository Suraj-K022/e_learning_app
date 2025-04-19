import 'dart:io';

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
  Map<String, bool> _checkboxValues = {
    "Lectures": false,
    "Images": false,
    "Pdfs": false,
    "Doubts": false,
    "Others": false,
  };

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileSize = await pickedFile.length(); // Get file size in bytes
      if (fileSize > 3 * 1024 * 1024) {
        // 3MB limit
        Get.snackbar("Error", "Image size exceeds 3MB limit",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          child: Poppins(
              text: 'Submit',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor),
          onPressed: () {
            Get.back(canPop: true);
          },
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
            children: [
              _buildCheckBoxItem("Lectures"),
              _buildCheckBoxItem("Images"),
              _buildCheckBoxItem("Pdfs"),
              _buildCheckBoxItem("Doubts"),
              _buildCheckBoxItem("Others"),
            ],
          ),
          SizedBox(height: 20),
          CustomTextField(
              hintText: 'Please describe the problem you faced', maxLines: 10),
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
                border:
                    Border.all(color: Get.theme.secondaryHeaderColor, width: 1),
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
              color: Get.theme.secondaryHeaderColor),
        ],
      ),
    );
  }
}
