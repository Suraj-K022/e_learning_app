import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/payment.dart';
import '../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../customWidgets/customtext.dart';
import '../../CourseDetailScreen/course_detail_screen.dart';

class CourseContentScreen extends StatelessWidget {
  final String imgUrl;
  final String videoUrl;
  final String pdfUrl;

  final String discription;

  final String heading;
  final String Title;
  CourseContentScreen({
    super.key,
    required this.Title,
    required this.heading,
    required this.discription,
    required this.videoUrl,
    required this.pdfUrl,
    required this.imgUrl,
  });

  final paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          // Obx(() => paymentController.isPaymentSuccessful.value ?
          Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
            child: Poppins(
              text: 'Watch Video Lectures',
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onPressed: () {
              String sanitize(String? url) {
                if (url == null) return '';
                return url.replaceAll(RegExp(r'^\[|\]$'), '');
              }

              final cleanImgUrl = sanitize(imgUrl);
              final cleanPdfUrl = sanitize(pdfUrl);
              final cleanVideoUrl = sanitize(videoUrl);

              Get.to(() => CourseDetailScreen(
                    imgUrl: cleanImgUrl,
                    pdfUrl: cleanPdfUrl,
                    videoUrl: cleanVideoUrl,
                    title: Title,
                    description: heading,
                  ));

              print(cleanImgUrl);
              print(cleanPdfUrl);
              print(cleanVideoUrl);
            }),
      ),

      // : SizedBox()),

      appBar: AppBar(
        title: Poppins(
          text: Title,
          color: Get.theme.secondaryHeaderColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
            onTap: () {
              Get.back(canPop: true);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Get.theme.secondaryHeaderColor,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(
            text: heading,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
            fontSize: 16,
            maxLines: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Poppins(
            text: discription,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
            fontSize: 16,
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
