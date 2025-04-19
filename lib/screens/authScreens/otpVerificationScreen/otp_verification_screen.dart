import 'package:e_learning_app/screens/Student/Student_Dashboard/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../customWidgets/custom_buttons.dart';
import '../../../customWidgets/customtext.dart';
import '../../../utils/images.dart';

import '../../Tutor/Tutor_Dashboard/tutor_dashboard.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String type;
  final String phNumber;
  const OtpVerificationScreen(
      {super.key, required this.phNumber, required this.type});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Poppins(
                  text: 'Didn’t get the OTP? ',
                  color: Get.theme.hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                Poppins(
                  text: 'Resend',
                  color: Get.theme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            CustomButton(
              child: Poppins(
                text: 'Submit OTP',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Get.theme.secondaryHeaderColor,
              ),
              onPressed: () => widget.type == 'Student'
                  ? Get.offAll(StudentDashboard(index: 0))
                  : widget.type == 'Tutor'
                      ? Get.offAll(TutorDashboard())
                      : SizedBox(),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Get.theme.primaryColor,
                ),
                height: Get.height * 0.4, // Responsive height
              ),
              Image.asset(Images.bglayer, width: Get.width, fit: BoxFit.cover),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.smalllogo,
                    height: 90,
                    color: Get.theme.secondaryHeaderColor,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Poppins(
                    text: 'E-Learning',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Get.theme.secondaryHeaderColor,
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Poppins(
                    text: 'Enter Verification Code',
                    fontSize: 20,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Poppins(
                    text: 'We’ll send a code to +917999995151',
                    fontSize: 16,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OtpTextField(
                  keyboardType: TextInputType.number,

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  styles: [
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    GoogleFonts.poppins(
                      color: Get.theme.secondaryHeaderColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                  fieldWidth: 50,
                  numberOfFields: 6,
                  borderColor: Colors.grey,
                  enabledBorderColor: Colors.grey.shade400,
                  focusedBorderColor: Get.theme.primaryColor,
                  borderWidth: 1,

                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                ),
                SizedBox(
                  height: 40,
                ),

                SizedBox(height: Get.height * 0.04),

                // Align(alignment: Alignment.center,child: Poppins(text: ' Expires in 01:00',color: Get.theme.hintColor,fontSize: 14,fontWeight: FontWeight.w400,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
