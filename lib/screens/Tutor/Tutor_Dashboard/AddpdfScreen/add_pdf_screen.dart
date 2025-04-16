import 'dart:io';

import 'package:e_learning_app/customWidgets/Custom_input_text_field.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../controller/course_Controller.dart';
import '../../../../customWidgets/custom_buttons.dart';


class AddPdfScreen extends StatefulWidget {
  // final String screenName;
  const AddPdfScreen({super.key});

  @override
  State<AddPdfScreen> createState() => _AddPdfScreenState();
}

class _AddPdfScreenState extends State<AddPdfScreen> {
  final List<File> collection = [];
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseContentController = TextEditingController();


  File? _pdfFile;
  File? _thumbnailFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile({
    required Future<XFile?> Function() pickFunction,
    required void Function(File file) onPicked,
  }) async {
    final XFile? picked = await pickFunction();
    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        onPicked(file);
        collection.add(file);
      });
    }
  }


  Future<void> _pickPDF() async {
    await _pickFile(
      pickFunction: () => _picker.pickMedia(),
      onPicked: (file) => _pdfFile = file,
    );
  }

  Future<void> _pickThumbnail() async {
    await _pickFile(
      pickFunction: () => _picker.pickImage(source: ImageSource.gallery),
      onPicked: (file) => _thumbnailFile = file,
    );
  }

  Future<void> save() async {
    if (courseNameController.text.isEmpty ||

        _thumbnailFile == null ||

        _pdfFile == null) {
      Get.snackbar("Missing Fields", "Please complete all fields and upload all files.");
      return;
    }

    final controller = Get.find<CourseController>();
    final result = await controller.addPdf(
      course: courseNameController.text,
      contentImg: _thumbnailFile!,
      contentPdf: _pdfFile!,
    );

    if (result.status == 200) {

    } else {
      Get.snackbar("Error", result.message);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onPressed: save,
          child: Poppins(
            text: 'Save Pdf',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Add PDF',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildLabel("Course Name"),
          const SizedBox(height: 8),
          CustomTextField(hintText: 'Course Name', controller: courseNameController),
          const SizedBox(height: 20),

          _buildFilePicker("Add Thumbnail", _pickThumbnail, _thumbnailFile),
          // const SizedBox(height: 20),

          _buildFilePicker("Add PDF", _pickPDF, _pdfFile),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Poppins(
      text: text,
      color: Get.theme.secondaryHeaderColor,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
  }

  Widget _buildFilePicker(String label, VoidCallback onTap, File? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(margin: EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Get.theme.hintColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Poppins(
                  text: label,
                  color: Get.theme.secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                Icon(Icons.arrow_forward_ios, color: Get.theme.secondaryHeaderColor),
              ],
            ),
          ),
        ),
        if (selectedFile != null) ...[
          // const SizedBox(height: 8),
          Poppins(
            text: 'Selected: ${selectedFile.path.split('/').last}',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.theme.hintColor,
            maxLines: 3,
          ),
          // const SizedBox(height: 20),
        ],
      ],
    );
  }
}
