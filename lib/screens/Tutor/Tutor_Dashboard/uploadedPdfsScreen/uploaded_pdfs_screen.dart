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
    Get.find<CourseController>().getPdfNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          child: Poppins(
            text: 'Add Pdfs',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
          onPressed: () {
            Get.to(AddPdfScreen());
          },
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios,
              size: 24, color: Get.theme.secondaryHeaderColor),
        ),
        title: Poppins(
          text: 'Uploaded Pdfs',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Get.theme.secondaryHeaderColor,
        ),
      ),
      body: GetBuilder<CourseController>(builder: (courseController) {
        final pdfList = courseController.getpdfNotes;

        return RefreshIndicator(
          color: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor,
          onRefresh: () async {
            await courseController.getPdfNotes();
          },
          child: pdfList.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: Get.height * 0.3),
                    Center(
                      child: Poppins(
                        text: 'No PDF Found',
                        color: Get.theme.hintColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: pdfList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final pdf = pdfList[index];
                    final isDeleteVisible = _showDelete.contains(index);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: Get.theme.cardColor,
                      child: ListTile(
                        onLongPress: () {
                          setState(() {
                            if (_showDelete.contains(index)) {
                              _showDelete.remove(index);
                            } else {
                              _showDelete.add(index);
                            }
                          });
                        },
                        leading: Poppins(
                          text: "${index + 1}",
                          color: Get.theme.secondaryHeaderColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        title: Poppins(
                          text: pdf.name.toString(),
                          color: Get.theme.secondaryHeaderColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        trailing: isDeleteVisible
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  // await courseController.deletePdf(pdf.id); // Make sure you have this method
                                  await courseController
                                      .getPdfNotes(); // Refresh after deletion
                                  setState(() {
                                    _showDelete.remove(index);
                                  });
                                },
                              )
                            : Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Get.theme.secondaryHeaderColor,
                              ),
                        onTap: () {
                          if (!isDeleteVisible) {
                            Get.to(PdfDetailScreen(
                              title: pdf.name.toString(),
                              description: '',
                              pdfPath: pdf.pdfUrl.toString(),
                            ));
                          }
                        },
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
