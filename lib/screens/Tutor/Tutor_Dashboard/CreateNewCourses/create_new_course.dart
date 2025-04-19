import 'dart:io';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../customWidgets/custom_buttons.dart';
import '../../../../customWidgets/customtext.dart';
import '../CoursesScreen/courses_screen.dart';

class CreateNewCourse extends StatefulWidget {
  final String courseName;
  final String ScreenName;

  const CreateNewCourse({
    super.key,
    required this.ScreenName,
    required this.courseName,
  });

  @override
  State<CreateNewCourse> createState() => _CreateNewCourseState();
}

class _CreateNewCourseState extends State<CreateNewCourse> {
  final List<File> collection = [];
  late TextEditingController courseNameController;
  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseContentController = TextEditingController();

  File? _videoFile;
  File? _pdfFile;
  File? _thumbnailFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  // Error states
  bool _titleError = false;
  bool _contentError = false;
  bool _thumbnailError = false;
  bool _videoError = false;
  bool _pdfError = false;

  // Saving state
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController(text: widget.courseName);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    courseNameController.dispose();
    super.dispose();
  }

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

  Future<void> _pickVideo() async {
    await _pickFile(
      pickFunction: () => _picker.pickVideo(source: ImageSource.gallery),
      onPicked: (file) {
        _videoFile = file;
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) => setState(() {}));
      },
    );
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
    setState(() => _isSaving = true);

    _titleError = courseTitleController.text.isEmpty;
    _contentError = courseContentController.text.isEmpty;
    _thumbnailError = _thumbnailFile == null;
    _videoError = _videoFile == null;
    _pdfError = _pdfFile == null;

    if (_titleError ||
        _contentError ||
        _thumbnailError ||
        _videoError ||
        _pdfError) {
      setState(() => _isSaving = false);
      Get.snackbar(
          "Missing Fields", "Please complete all fields and upload all files.");
      return;
    }

    try {
      final value = await Get.find<CourseController>().addContent(
        course: courseNameController.text,
        title: courseTitleController.text,
        description: courseContentController.text,
        contentImg: File(_thumbnailFile!.path),
        contentVideo: File(_videoFile!.path),
        contentPdf: File(_pdfFile!.path),
      );

      debugPrint("Response Status: ${value.status}");

      if (value.status == 200) {
        await Get.find<CourseController>().getAllCourses();

        if (widget.ScreenName == 'CourseContentScreen') {
          Get.close(1);
        } else if (widget.ScreenName == 'TutorDashboard') {
          Get.to(() => CoursesScreen());
        }
      } else {
        debugPrint("Navigation skipped because status is not 200.");
      }
    } catch (e) {
      debugPrint("Error during save: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: _isSaving
            ? Center(
                child: CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ))
            : CustomButton(
                onPressed: save,
                child: Poppins(
                  text: 'Save Course',
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
          text: 'Add Course',
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
          _buildLabel("Course Name"),
          const SizedBox(height: 8),
          widget.courseName.isEmpty
              ? CustomTextField(
                  hintText: 'Course Name',
                  controller: courseNameController,
                )
              : _buildCourseNameDisplay(widget.courseName),
          const SizedBox(height: 20),
          _buildLabel("Course Title"),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Course Title',
            controller: courseTitleController,
            errorText: _titleError ? 'Course title is required' : null,
          ),
          const SizedBox(height: 20),
          _buildLabel("Add Content"),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Add Content',
            controller: courseContentController,
            maxLines: 100,
            errorText: _contentError ? 'Content description is required' : null,
          ),
          const SizedBox(height: 20),
          _buildFilePicker("Add Thumbnail", _pickThumbnail, _thumbnailFile,
              error: _thumbnailError ? 'Thumbnail is required' : null),
          const SizedBox(height: 20),
          _buildFilePicker("Upload Video", _pickVideo, _videoFile,
              error: _videoError ? 'Video is required' : null),
          const SizedBox(height: 20),
          _buildFilePicker("Add PDF", _pickPDF, _pdfFile,
              error: _pdfError ? 'PDF is required' : null),
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

  Widget _buildCourseNameDisplay(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Get.theme.hintColor),
      ),
      child: Poppins(
        text: name,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Get.theme.secondaryHeaderColor,
      ),
    );
  }

  Widget _buildFilePicker(
    String label,
    VoidCallback onTap,
    File? selectedFile, {
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
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
          Poppins(
            text: 'Selected: ${selectedFile.path.split('/').last}',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.theme.hintColor,
            maxLines: 3,
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 8),
          Poppins(
            text: error,
            color: Colors.red,
            fontSize: 12,
          ),
        ],
      ],
    );
  }
}
