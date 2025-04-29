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
    return Scaffold(
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
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Poppins(
              text: widget.description,
              maxLines: 100,
              fontWeight: FontWeight.w500,
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            Expanded(
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
