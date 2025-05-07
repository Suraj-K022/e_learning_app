import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../customWidgets/customtext.dart';

class PdfDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String pdfPath; // Added for local file support

  const PdfDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.pdfPath, // Accepts both local & network paths
  });

  @override
  State<PdfDetailScreen> createState() => _PdfDetailScreenState();
}

class _PdfDetailScreenState extends State<PdfDetailScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: widget.title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Poppins(
                text: widget.description,
                maxLines: 100,
                fontWeight: FontWeight.w500,
                color: Get.theme.secondaryHeaderColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75, // or a fixed height like 500
              child: isError
                  ? Center(
                child: Poppins(
                  text: "Failed to load PDF!",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.hintColor,
                ),
              )
                  : widget.pdfPath.startsWith("http")
                  ? SfPdfViewer.network(

                widget.pdfPath,
                key: _pdfViewerKey,
                onDocumentLoadFailed: (details) {
                  setState(() {
                    isError = true;
                  });
                },
              )
                  : File(widget.pdfPath).existsSync()
                  ? SfPdfViewer.file(
                File(widget.pdfPath),
                key: _pdfViewerKey,
                onDocumentLoadFailed: (details) {
                  setState(() {
                    isError = true;
                  });
                },
              )
                  : Center(
                child: Poppins(
                  text: "PDF not found!",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


}
