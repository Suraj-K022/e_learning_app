import 'dart:io';
import 'dart:ui';

import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/PaidCoursesList/AddNewPaidCourse/PaidCourseContentList/paid_course_content_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../controller/course_Controller.dart';
import '../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../customWidgets/customtext.dart';

class AddPaidCourseContent extends StatefulWidget {
  final String courseName;
  final String courseId;

  const AddPaidCourseContent({
    super.key,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<AddPaidCourseContent> createState() => _AddPaidCourseContentState();
}

class _AddPaidCourseContentState extends State<AddPaidCourseContent> {
  final _picker = ImagePicker();
  final List<File> collection = [];

  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseContentController = TextEditingController();
  late final TextEditingController courseNameController;

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
        onPicked(file);
      }
    } catch (e) {
      debugPrint("File picking error: $e");
    }
  }

  Future<void> _pickThumbnail() async {
    await _pickFile(
      pickFunction: () => _picker.pickImage(source: ImageSource.gallery),
      onPicked: (file) {
        final sizeInMB = file.lengthSync() / (1024 * 1024);
        if (sizeInMB > 2) {
          Get.snackbar("File Too Large", "Thumbnail image must be less than 2MB.");
          return;
        }
        setState(() {
          _thumbnailFile = file;
          collection.add(file);
        });
      },
    );
  }

  Future<void> _pickVideo() async {
    await _pickFile(
      pickFunction: () => _picker.pickVideo(source: ImageSource.gallery),
      onPicked: (file) {
        setState(() {
          _videoFile = file;
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(file)
            ..initialize().then((_) => setState(() {}));
          collection.add(file);
        });
      },
    );
  }

  Future<void> _pickPDF() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _pdfFile = file;
          collection.add(file);
        });
      }
    } catch (e) {
      debugPrint("PDF pick error: $e");
    }
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

    Get.find<CourseController>()
        .addPaidCourseContent(
      courseId: widget.courseId,
      course: courseNameController.text,
      title: courseTitleController.text,
      description: courseContentController.text,
      contentImg: _thumbnailFile!,
      contentVideo: _videoFile!,
      contentPdf: _pdfFile!,
    )
        .then((response) async {
      if (response.status == 200) {

        Get.off(PaidCourseContentList(courseId: widget.courseId, appbarTitle: widget.courseName));

      } else {
        Get.snackbar("Upload Failed", "Course was not saved. Try again.");
      }
    })
        .catchError((e) {
      debugPrint("Save Error: $e");
      Get.snackbar("Error", "Something went wrong. Please try again.");
    })
        .whenComplete(() {
      setState(() => _isSaving = false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Poppins(
          text: 'Add Contents',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
          onPressed: () => Get.close(1),
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
                  ? CustomTextField(controller: courseNameController, hintText: 'Course Name')
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
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          if (_isSaving)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
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
            text: 'Save Course Content',
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
              child: Image.file(selectedFile, height: 100, fit: BoxFit.cover),
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
