import 'package:e_learning_app/CustomWidgets/custom_snackbar.dart';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../../customWidgets/custom_buttons.dart';
import '../../../../../customWidgets/customtext.dart';
import '../CoursePreviewList/courseContent/course_content_screen.dart';

class AvailablePaidCourseScreen extends StatefulWidget {
  final String videoUrl;
  final String imgUrl;
  final String pdfUrl;
  final String courseId;
  final String title;
  final String amount;

  AvailablePaidCourseScreen({
    super.key,
    required this.title,
    required this.courseId,
    required this.videoUrl,
    required this.imgUrl,
    required this.pdfUrl,
    required this.amount,
  });

  @override
  State<AvailablePaidCourseScreen> createState() => _AvailablePaidCourseScreenState();
}

class _AvailablePaidCourseScreenState extends State<AvailablePaidCourseScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllContent(widget.courseId);
      Get.find<AuthController>().getProfile();
    });

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final auth = Get.find<AuthController>();
    Get.find<CourseController>().postTransactions(
      courseName: widget.title,
      studentName: auth.profileModel?.name ?? "Unknown",
      paymentMethod: "Razorpay",
      amount: widget.amount,
      transactionId: response.paymentId.toString(),
    );

    Get.snackbar("Payment Success", "Transaction ID: ${response.paymentId}");
    Get.back();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet Selected", response.walletName ?? "Unknown");
  }

  void _startPayment() {
    final auth = Get.find<AuthController>();

    var amountInPaise = ((double.tryParse(widget.amount) ?? 0) * 100).toInt();

    var options = {
      'key': 'rzp_test_WZu8B3H1Bec0W9', // Replace with prod key in production
      'amount': amountInPaise,
      'name': widget.title,
      'description': 'Full course access',
      'prefill': {
        'contact': auth.profileModel?.mobile ?? '',
        'Name': auth.profileModel?.username ?? '',
        'email': auth.profileModel?.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Payment error: $e");
    }
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
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor, size: 24),
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
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final content = contentList[index];

                return ListTile(
                  onTap: () {
                    final videoUrl = content.vedioUpload ?? '';
                    final pdfUrl = content.pdfUpload ?? '';
                    final imgUrl = content.contentImage ?? '';
                    final description = content.description ?? '';

                    // if (videoUrl.isEmpty && pdfUrl.isEmpty) {
                    //   customSnackbar("No content", "This item has no available resources.");
                    //   return;
                    // }

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
                      errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Poppins(
                    text: content.title ?? '',
                    fontSize: 14,
                    maxLines: 2,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w400,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Get.theme.secondaryHeaderColor),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<AuthController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: CustomButton(
              onPressed: _showPaymentBottomSheet,
              child: Poppins(
                text: 'Get Full Course Access at Only ₹${widget.amount}!',
                maxLines: 2,
                textAlign: TextAlign.center,
                color: Get.theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPaymentBottomSheet() {
    Get.bottomSheet(
      GetBuilder<AuthController>(
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 10),
                ..._benefitList(),
                const SizedBox(height: 15),
                CustomButton(
                  onPressed: () {
                    _startPayment();
                    Get.back();
                  },
                  child: Poppins(
                    text: 'Pay ₹${widget.amount}',
                    color: Get.theme.scaffoldBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  List<Widget> _benefitList() {
    return [
      _buildBenefit("Comprehensive Learning", "Structured notes & expert-led video lectures."),
      _buildBenefit("Study Anytime, Anywhere", "Access PDFs & videos on the go, at your own pace."),
      _buildBenefit("Exam-Ready Content", "Concise notes for quick and effective revision."),
      _buildBenefit("Cost-Effective", "Save money while accessing premium learning material."),
      _buildBenefit("Better Retention", "Visual & written content together boost understanding."),
      _buildBenefit("Doubt Clearance", "Step-by-step explanations simplify complex topics."),
    ];
  }

  Widget _buildBenefit(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$title\n$description",
              style: GoogleFonts.poppins(
                color: Get.theme.secondaryHeaderColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
