import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:e_learning_app/customWidgets/custom_buttons.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentHome/PdfDetailScreen/pdf_detail_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddpdfScreen/add_pdf_screen.dart';
import 'package:e_learning_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadedPdfsScreen extends StatefulWidget {
  const UploadedPdfsScreen({super.key});

  @override
  State<UploadedPdfsScreen> createState() => _UploadedPdfsScreenState();
}

class _UploadedPdfsScreenState extends State<UploadedPdfsScreen> {
  final Set<int> _showDelete = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getPdfNotes();
    });
  }

  Future<void> _onRefresh() async {
    await Get.find<CourseController>().getPdfNotes();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (courseController) {
      final pdfList = courseController.getpdfNotes;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
            onPressed: () => Get.close(1),
          ),
          title: Poppins(
            text: 'Uploaded Pdfs',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          child: pdfList.isEmpty
              ? Center(child: Poppins(text: 'No PDF Notes found',fontWeight: FontWeight.w500,fontSize: 14,color: Get.theme.secondaryHeaderColor,))
              : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: pdfList.length,
            itemBuilder: (context, index) {
              final pdf = pdfList[index];
              final isDeleteVisible = _showDelete.contains(index);
              final title = (pdf.name ?? '').trim().isEmpty ? 'Untitled PDF' : pdf.name!;
              final id = pdf.id?.toString() ?? '';

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      if (!isDeleteVisible) {
                        Get.to(() => PdfDetailScreen(
                          title: title,
                          description: '',
                          pdfPath: pdf.pdfUrl.toString(),
                        ));
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        isDeleteVisible
                            ? _showDelete.remove(index)
                            : _showDelete.add(index);
                      });
                    },
                    tileColor: Get.theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    leading: Container(
                      height: 35,
                      width: 35,
                      color: Get.theme.scaffoldBackgroundColor,
                      child: Image.network(
                        pdf.imageUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.picture_as_pdf),
                      ),
                    ),
                    title: Poppins(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    subtitle: Poppins(
                      text: 'PDF Resource',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Get.theme.hintColor,
                    ),
                    trailing: isDeleteVisible
                        ? IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await courseController.deletePdfs(int.parse(id));
                        await _onRefresh();
                        setState(() => _showDelete.remove(index));
                      },
                    )
                        : Icon(Icons.arrow_forward_ios, size: 20, color: Get.theme.secondaryHeaderColor),
                  ),
                  SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomButton(
            onPressed: () => Get.to(() => AddPdfScreen()),
            child: Poppins(
              text: 'Add Pdfs',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Get.theme.scaffoldBackgroundColor,
            ),
          ),
        ),
      );
    });
  }
}
