import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';  // Import for BackdropFilter

import '../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../customWidgets/custom_buttons.dart';
import '../../../../customWidgets/customtext.dart';
import '../../../../controller/course_Controller.dart';
import '../CoursesScreen/courses_screen.dart';

class CreateNewCourse extends StatefulWidget {
  final String courseName;
  final String courseId;

  const CreateNewCourse({
    super.key,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<CreateNewCourse> createState() => _CreateNewCourseState();
}

class _CreateNewCourseState extends State<CreateNewCourse> {
  final _picker = ImagePicker();

  final List<File> collection = [];
  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseContentController = TextEditingController();
  late TextEditingController courseNameController;

  File? _thumbnailFile;
  File? _videoFile;
  File? _pdfFile;
  VideoPlayerController? _videoController;

  bool _isSaving = false;

  bool _titleError = false;
  bool _contentError = false;
  bool _thumbnailError = false;
  bool _videoError = false;
  bool _pdfError = false;

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
    try {
      final XFile? picked = await pickFunction();
      if (picked != null) {
        final file = File(picked.path);
        debugPrint("Picked file: ${file.path}");
        setState(() {
          onPicked(file);
          collection.add(file);
        });
      }
    } catch (e) {
      debugPrint("File picking error: $e");
    }
  }

  Future<void> _pickThumbnail() async {
    await _pickFile(
      pickFunction: () => _picker.pickImage(source: ImageSource.gallery),
      onPicked: (file) {
        final bytes = file.lengthSync();
        final sizeInMB = bytes / (1024 * 1024);
        if (sizeInMB > 2) {
          Get.snackbar("File Too Large", "Thumbnail image must be less than 2MB.");
          return;
        }
        _thumbnailFile = file;
      },
    );
  }

  Future<void> _pickVideo() async {
    await _pickFile(
      pickFunction: () => _picker.pickVideo(source: ImageSource.gallery),
      onPicked: (file) {
        _videoFile = file;
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(file)
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

  Future<void> _saveCourse() async {
    setState(() => _isSaving = true);

    _titleError = courseTitleController.text.isEmpty;
    _contentError = courseContentController.text.isEmpty;
    _thumbnailError = _thumbnailFile == null;
    _videoError = _videoFile == null;
    _pdfError = _pdfFile == null;

    if (_titleError || _contentError || _thumbnailError || _videoError || _pdfError) {
      setState(() => _isSaving = false);
      return;
    }

    try {
      final response = await Get.find<CourseController>().addContent(
        course: courseNameController.text,
        title: courseTitleController.text,
        description: courseContentController.text,
        contentImg: _thumbnailFile!,
        contentVideo: _videoFile!,
        contentPdf: _pdfFile!,
      );

      debugPrint("Upload status: ${response.status}");

      if (response.status == 200) {
        await Get.find<CourseController>().getAllCourses();
        Get.find<CourseController>().getAllContent(widget.courseId);
        Get.close(1);
      } else {
        Get.snackbar("Upload Failed", "Course was not saved. Try again.");
      }
    } catch (e) {
      debugPrint("Save Error: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Poppins(
          text: 'Add Course',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildLabel("Course Name"),
              const SizedBox(height: 8),
              widget.courseName.isEmpty
                  ? CustomTextField(
                controller: courseNameController,
                hintText: 'Course Name',
              )
                  : _readOnlyDisplay(widget.courseName),
              const SizedBox(height: 20),

              _buildLabel("Course Title"),
              const SizedBox(height: 8),
              CustomTextField(
                controller: courseTitleController,
                hintText: 'Course Title',
                errorText: _titleError ? 'Course title is required' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Add Content"),
              const SizedBox(height: 8),
              CustomTextField(
                controller: courseContentController,
                hintText: 'Add Content',
                maxLines: 100,
                errorText: _contentError ? 'Content description is required' : null,
              ),
              const SizedBox(height: 20),

              _filePicker("Add Thumbnail", _pickThumbnail, _thumbnailFile,
                  error: _thumbnailError ? 'Thumbnail is required' : null, isImage: true),
              const SizedBox(height: 20),

              _filePicker("Upload Video", _pickVideo, _videoFile,
                  error: _videoError ? 'Video is required' : null),
              const SizedBox(height: 20),

              _filePicker("Add PDF", _pickPDF, _pdfFile,
                  error: _pdfError ? 'PDF is required' : null),
            ],
          ),
          if (_isSaving)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),  // Dark overlay behind the blur
                ),
              ),
            ),
          if (_isSaving)
            Center(
              child: CircularProgressIndicator(
                color: Colors.blue,  // Spinner color
                strokeWidth: 4,
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onPressed: _isSaving ? null : _saveCourse,
          child: Poppins(
            text: 'Save Course',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Poppins(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Get.theme.secondaryHeaderColor,
    );
  }

  Widget _readOnlyDisplay(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Get.theme.hintColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Poppins(
        text: value,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Get.theme.secondaryHeaderColor,
      ),
    );
  }

  Widget _filePicker(String label, VoidCallback onTap, File? selectedFile,
      {String? error, bool isImage = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Get.theme.hintColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Poppins(
                  text: label,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.secondaryHeaderColor,
                ),
                Icon(Icons.arrow_forward_ios, color: Get.theme.secondaryHeaderColor),
              ],
            ),
          ),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 8),
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                selectedFile,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
          else
            Poppins(
              text: 'Selected: ${selectedFile.path.split('/').last}',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
            ),
        ],
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Poppins(
              text: error,
              fontSize: 12,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
