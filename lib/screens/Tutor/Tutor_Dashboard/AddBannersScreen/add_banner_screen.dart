import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controller/course_Controller.dart';
import '../../../../customWidgets/custom_buttons.dart';
import '../../../../customWidgets/customtext.dart';

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CourseController>().getBanner();

    },);
  }

  final List<File> collection = [];
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

  Future<void> _pickThumbnail() async {
    await _pickFile(
      pickFunction: () => _picker.pickImage(source: ImageSource.gallery),
      onPicked: (file) => _thumbnailFile = file,
    );
  }

  Future<void> save() async {
    if (_thumbnailFile == null) {
      Get.snackbar("Missing Fields", "Please select a banner image.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final controller = Get.find<CourseController>();
    final result = await controller.addBanner(contentImg: _thumbnailFile!);

    setState(() {
      _isLoading = false;
    });

    if (result.status == 200) {
      Get.back();
      Get.snackbar("Success", "Banner uploaded successfully.");
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
            text: _isLoading ? 'Uploading...' : 'Save Banner',
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
          text: 'Add Banners',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child:
              Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildFilePicker("Pick Banner", _pickThumbnail, _thumbnailFile),
        ],
      ),
    );
  }

  Widget _buildFilePicker(
      String label, VoidCallback onTap, File? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                Icon(Icons.arrow_forward_ios,
                    color: Get.theme.secondaryHeaderColor),
              ],
            ),
          ),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 8),
          Image.file(selectedFile,
              height: 150, width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Poppins(
            text: 'Selected: ${selectedFile.path.split('/').last}',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.theme.hintColor,
          ),
        ],
      ],
    );
  }
}
