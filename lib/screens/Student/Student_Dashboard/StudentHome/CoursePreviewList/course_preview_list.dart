import 'package:e_learning_app/CustomWidgets/custom_snackbar.dart';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../../customWidgets/custom_buttons.dart';
import '../../../../../customWidgets/customtext.dart';
import 'courseContent/course_content_screen.dart';

class CoursePreviewList extends StatefulWidget {
  final String videoUrl;
  final String imgUrl;
  final String pdfUrl;
  final String courseId;
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


  late Razorpay _razorpay;


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar(
        "Payment Success", "Transaction ID: ${response.paymentId}");
   Get.back();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet Selected", response.walletName ?? "Unknown");
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_WZu8B3H1Bec0W9', // Replace with actual Razorpay key
      'amount': 100000, // Amount in paise (₹199.00)
      'name': 'Premium Subscription',
      'description': 'Subscription for premium features',
      'prefill': {
        'contact': '1234567890',
        'email': 'user@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up listeners
    super.dispose();
  }




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllContent(widget.courseId);
    });

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

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
            return Center(child: Text("No content available"));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.separated(
              itemCount: contentList.length,
              itemBuilder: (context, index) {
                final content = contentList[index];

                return ListTile(
                  onTap: () {
                    final contentData = contentList.length > index
                        ? contentList[index]
                        : null;

                    final videoUrl = contentData?.vedioUpload ?? '';
                    final pdfUrl = contentData?.pdfUpload ?? '';
                    final imgUrl = contentData?.contentImage ?? '';
                    final description = contentData?.description ?? '';

                    Get.to(() => CourseContentScreen(
                      imgUrl: imgUrl,
                      videoUrl: videoUrl.toString(),
                      pdfUrl: pdfUrl.toString(),
                      discription: description,
                      heading: content.title ?? '',
                      Title: widget.title,
                    ));
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
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(24),
      //   child: CustomButton(
      //     onPressed: _showPaymentBottomSheet,
      //     child: Poppins(
      //       text: 'Get Full Course Access at Only ₹249!',
      //       maxLines: 2,
      //       textAlign: TextAlign.center,
      //       color: Get.theme.scaffoldBackgroundColor,
      //       fontWeight: FontWeight.w500,
      //       fontSize: 14,
      //     ),
      //   ),
      // ),
    );
  }

  // void _showPaymentBottomSheet() {
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.all(16.0),
  //       decoration: BoxDecoration(
  //         color: Get.theme.cardColor,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Poppins(
  //             text: "📚 Why Choose Full Course PDFs & Videos?",
  //             color: Get.theme.secondaryHeaderColor,
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             textAlign: TextAlign.center,
  //             maxLines: 2,
  //           ),
  //           SizedBox(height: 10),
  //           ..._benefitList(),
  //           SizedBox(height: 15),
  //           CustomButton(
  //             onPressed: () {
  //               // Add logic here for alternate purchase access
  //               _startPayment();
  //
  //          Get.back();
  //             },
  //             child: Poppins(
  //               text: 'Pay ₹249',
  //               color: Get.theme.scaffoldBackgroundColor,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //   );
  // }
  //
  // List<Widget> _benefitList() {
  //   return [
  //     _buildBenefit("Comprehensive Learning",
  //         "Structured notes & expert-led video lectures."),
  //     _buildBenefit("Study Anytime, Anywhere",
  //         "Access PDFs & videos on the go, at your own pace."),
  //     _buildBenefit("Exam-Ready Content",
  //         "Concise notes for quick and effective revision."),
  //     _buildBenefit("Cost-Effective",
  //         "Save money while accessing premium learning material."),
  //     _buildBenefit("Better Retention",
  //         "Visual & written content together boost understanding."),
  //     _buildBenefit("Doubt Clearance",
  //         "Step-by-step explanations simplify complex topics."),
  //   ];
  // }
  //
  // Widget _buildBenefit(String title, String description) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Icon(Icons.check_circle, color: Colors.green),
  //         SizedBox(width: 8),
  //         Expanded(
  //           child: Text("$title\n$description",
  //               style: GoogleFonts.poppins(
  //                   color: Get.theme.secondaryHeaderColor, fontSize: 12)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
