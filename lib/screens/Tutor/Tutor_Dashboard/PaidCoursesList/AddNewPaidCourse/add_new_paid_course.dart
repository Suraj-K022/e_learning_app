import 'dart:io';

import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../customWidgets/customtext.dart';

class AddNewPaidCourse extends StatefulWidget {
  const AddNewPaidCourse({super.key});

  @override
  State<AddNewPaidCourse> createState() => _AddNewPaidCourseState();
}

class _AddNewPaidCourseState extends State<AddNewPaidCourse> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _actualPriceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _thumbnailFile;
  String? _thumbnailPath;

  String? _courseNameError;
  String? _thumbnailError;
  String? _actualPriceError;
  String? _discountPriceError;

  bool _isLoading = false;

  Future<void> _pickThumbnail() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = file.lengthSync();
      final sizeInMB = bytes / (1024 * 1024);

      if (sizeInMB > 2) {
        Get.snackbar("File Too Large", "Thumbnail image must be less than 2MB.");
        return;
      }

      setState(() {
        _thumbnailFile = file;
        _thumbnailPath = pickedFile.path;
        _thumbnailError = null;
      });
    }
  }

  void _saveCourse() {
    final courseName = _courseNameController.text.trim();
    final actualPriceText = _actualPriceController.text.trim();
    final discountPriceText = _discountPriceController.text.trim();

    setState(() {
      _courseNameError = courseName.isEmpty ? 'Course name is required' : null;
      _actualPriceError = actualPriceText.isEmpty
          ? 'Price is required'
          : double.tryParse(actualPriceText) == null || double.parse(actualPriceText) <= 0
          ? 'Enter a valid price'
          : null;





      _discountPriceError = discountPriceText.isEmpty
          ? 'Price is required'
          : double.tryParse(discountPriceText) == null || double.parse(discountPriceText) <= 0
          ? 'Enter a valid price'
          : null;
      _thumbnailError = _thumbnailPath == null ? 'Thumbnail is required' : null;




    });

    if (_courseNameError != null || _thumbnailError != null || _actualPriceError != null|| _discountPriceError != null ) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Get.find<CourseController>()
        .addPaidCourse(
      courseName: courseName,
      teacherName: Get.find<AuthController>().profileModel!.username.toString(),
      actualPrice: actualPriceText,
      discountPrice: discountPriceText,
      thumbnailImg: [_thumbnailPath!],
    )
        .then((response) {
      if (response.status == 200) {
        Get.close(1);
        Get.find<CourseController>().getMyPaidCourses();

        _courseNameController.clear();
        _actualPriceController.clear();
        _discountPriceController.clear();
        setState(() {
          _thumbnailFile = null;
          _thumbnailPath = null;
        });
      } else {
        Get.snackbar('Error', response.message);
      }
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to add course: $error');
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onPressed: _isLoading ? null : _saveCourse,
          child: _isLoading
              ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Get.theme.scaffoldBackgroundColor,
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Poppins(
            text: 'Add Course',
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
          child: Icon(Icons.arrow_back_ios_new,
              size: 24, color: Get.theme.secondaryHeaderColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
              text: 'Add Course',
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Add Course',
            controller: _courseNameController,
            errorText: _courseNameError,
          ),
          const SizedBox(height: 20),
          Row(spacing: 16,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(
                        text: 'Actual Price',
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor),
                    const SizedBox(height: 8),
                    CustomTextField(
                      prefixIcon: Icons.currency_rupee_rounded,
                      prefixIconSize: 20,
                      hintText: 'Price',
                      maxDigits: 4,
                      keyboardType: TextInputType.number,
                      controller:_actualPriceController,
                      errorText: _actualPriceError,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(
                        text: 'Discount Price',
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor),
                    const SizedBox(height: 8),
                    CustomTextField(
                      prefixIcon: Icons.currency_rupee_rounded,
                      prefixIconSize: 20,
                      hintText: 'Price',
                      maxDigits: 4,
                      keyboardType: TextInputType.number,
                      controller: _discountPriceController,
                      errorText: _discountPriceError,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          if (_thumbnailError != null) ...[
            const SizedBox(height: 8),
            Poppins(
              text: _thumbnailError!,
              color: Colors.red,
              fontSize: 12,
            ),
          ],
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
              child: Image.file(
                _thumbnailFile!,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
