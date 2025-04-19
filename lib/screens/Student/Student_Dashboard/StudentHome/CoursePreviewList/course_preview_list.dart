import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/payment.dart';
import '../../../../../customWidgets/custom_buttons.dart';
import '../../../../../customWidgets/customtext.dart';

import 'courseContent/course_content_screen.dart';

class CoursePreviewList extends StatefulWidget {
  final String videoUrl;
  final String imgUrl;
  final String pdfUrl;
  final String courseId;
  final paymentController = Get.put(PaymentController());

  final String title;
  CoursePreviewList({
    super.key,
    required this.title,
    required this.courseId,
    required this.videoUrl,
    required this.imgUrl,
    required this.pdfUrl,
  });

  @override
  State<CoursePreviewList> createState() => _CoursePreviewListState();
}

class _CoursePreviewListState extends State<CoursePreviewList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllContent(widget.courseId);
    });
  }

  // late Razorpay _razorpay;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }
  //
  // @override
  // void dispose() {
  //   _razorpay.clear(); // Clean up listeners
  //   super.dispose();
  // }
  //
  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   final paymentController = Get.find<PaymentController>();
  //   paymentController.isPaymentSuccessful.value = true;
  //
  //   Get.snackbar(
  //     "Payment Success",
  //     "Transaction ID: ${response.paymentId}",
  //     colorText: Get.theme.secondaryHeaderColor,
  //     backgroundColor: Get.theme.cardColor,
  //   );
  //
  //   Future.delayed(Duration(seconds: 2), () {
  //     Get.back(); // Allow some time before navigating back
  //   });
  // }
  //
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Get.snackbar(colorText: Get.theme.secondaryHeaderColor,backgroundColor: Get.theme.cardColor,"Payment Failed", response.message ?? "Something went wrong");
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Get.snackbar(colorText: Get.theme.secondaryHeaderColor,backgroundColor: Get.theme.cardColor,"External Wallet Selected", response.walletName ?? "Unknown");
  // }

  // void _startPayment() {
  //   var options = {
  //     'key': 'rzp_test_WZu8B3H1Bec0W9',
  //     'amount': 24900, // ₹249 in paise
  //     'name': 'Premium Subscription',
  //     'description': 'Subscription for premium features',
  //     'prefill': {
  //       'contact': '1234567890',
  //       'email': 'user@example.com',
  //     },
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //   }
  // // }
  //
  // final List<String> topics = [
  //   "Variables & data Types",
  //   "Control Flow (if-else, loops)",
  //   "Functions & Modules",
  //   "Object-Oriented Programming (OOP)",
  //   "File Handling",
  //   "Error Handling (try-except)",
  //   "Libraries (NumPy, Pandas, Matplotlib)",
  //   "Web Scraping (BeautifulSoup, Selenium)",
  //   "Django & Flask (Web Development)",
  //   "Machine Learning (Scikit-Learn, TensorFlow)",
  //   "data Science & Analysis",
  //   "Cybersecurity & Ethical Hacking",
  // ];

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Get.theme.secondaryHeaderColor, size: 24),
            onPressed: () => Get.back(),
          ),
        ),
        body: GetBuilder<CourseController>(
          builder: (courseController) {
            final contentList = courseController.allContentList;

            if (contentList == null || contentList.isEmpty) {
              return Center(
                child: Text("No content available"),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                itemCount: contentList.length,
                itemBuilder: (context, index) {
                  final content = contentList[index];

                  return ListTile(
                    onTap: () {
                      final content = contentList[index];
                      final contentData = (courseController.allContentList !=
                                  null &&
                              courseController.allContentList!.length > index)
                          ? courseController.allContentList![index]
                          : null;

                      final videoUrl =
                          contentData?.vedioUpload?.toString() ?? '';
                      final pdfUrl = contentData?.pdfUpload?.toString() ?? '';
                      final imgUrl =
                          contentData?.contentImage?.toString() ?? '';
                      final description =
                          contentData?.description?.toString() ?? '';

                      Get.to(() => CourseContentScreen(
                            imgUrl: imgUrl,
                            videoUrl: videoUrl,
                            pdfUrl: pdfUrl,
                            discription: description,
                            heading: content.title.toString(),
                            Title: widget.title,
                          ));
                      print(imgUrl);
                      print(videoUrl);
                      print(pdfUrl);
                      print(description);
                      print(content.title.toString());
                      print(widget.title);
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    tileColor: Get.theme.cardColor,
                    leading: Container(
                      height: 40,
                      width: 40,
                      color: Get.theme.secondaryHeaderColor,
                      child: Image.network(
                        content.contentImage ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Poppins(
                      text: content.title ?? '',
                      fontSize: 14,
                      maxLines: 2,
                      color: Get.theme.secondaryHeaderColor,
                      fontWeight: FontWeight.w400,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 20, color: Get.theme.secondaryHeaderColor),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            );
          },
        ),
        bottomNavigationBar:
            //
            // Obx(() {
            //   final paymentController = Get.find<PaymentController>();
            //   return paymentController.isPaymentSuccessful.value
            //       ? const SizedBox()
            //       :
            Padding(
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            onPressed: _showPaymentBottomSheet,
            child: Poppins(
              text: 'Get Full Course Access at Only ₹249!',
              maxLines: 2,
              textAlign: TextAlign.center,
              color: Get.theme.secondaryHeaderColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        )
        // })

        );
  }

  void _showPaymentBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Poppins(
              text: "📚 Why Choose Full Course PDFs & Videos?",
              color: Get.theme.secondaryHeaderColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(height: 10),
            ..._benefitList(),
            SizedBox(height: 15),
            CustomButton(
                child: Poppins(
                  text: 'Pay ₹249',
                  color: Get.theme.secondaryHeaderColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () {
                  // _startPayment();Get.back();
                }),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  List<Widget> _benefitList() {
    return [
      _buildBenefit("Comprehensive Learning",
          "Structured notes & expert-led video lectures."),
      _buildBenefit("Study Anytime, Anywhere",
          "Access PDFs & videos on the go, at your own pace."),
      _buildBenefit("Exam-Ready Content",
          "Concise notes for quick and effective revision."),
      _buildBenefit("Cost-Effective",
          "Save money while accessing premium learning material."),
      _buildBenefit("Better Retention",
          "Visual & written content together boost understanding."),
      _buildBenefit("Doubt Clearance",
          "Step-by-step explanations simplify complex topics."),
    ];
  }

  Widget _buildBenefit(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text("$title\n$description",
                style: GoogleFonts.poppins(
                    color: Get.theme.secondaryHeaderColor, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
