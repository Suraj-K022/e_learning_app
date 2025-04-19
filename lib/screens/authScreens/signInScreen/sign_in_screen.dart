import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/customWidgets/customtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../controller/auth_controller.dart';
import '../../../customWidgets/Custom_input_text_field.dart';
import '../../../customWidgets/custom_buttons.dart';
import '../../../utils/images.dart';
import '../../Student/Student_Dashboard/student_dashboard.dart';
import '../../Tutor/Tutor_Dashboard/tutor_dashboard.dart';
import '../otpVerificationScreen/otp_verification_screen.dart';
import '../SignUpScreen/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  final String type;

  const SignInScreen({super.key, required this.type});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Future<void> handleGoogleSignIn() async {
  //   try {
  //     final googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return;
  //
  //     final googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     final user = userCredential.user;
  //
  //     if (user != null) {
  //       final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //       final userDoc = await userDocRef.get();
  //
  //       if (!userDoc.exists || !(userDoc.data()?.containsKey('type') ?? false)) {
  //         // Save type and email if new or missing
  //         await userDocRef.set({
  //           'email': user.email,
  //           'type': widget.type,
  //         }, SetOptions(merge: true));
  //       }
  //
  //       // Get the type from Firestore (fallback to widget.type)
  //       final userData = (await userDocRef.get()).data();
  //       final type = userData?['type'] ?? widget.type;
  //
  //       if (type == "Student") {
  //         Get.off(() => StudentDashboard(index: 0));
  //       } else if (type == "Teacher" || type == "Tutor") {
  //         Get.off(() => TutorDashboard());
  //       } else {
  //         // Optional fallback or error handling
  //         print("Unknown user type: $type");
  //       }
  //     }
  //   } catch (e) {
  //     print('Google Sign-In failed: $e');
  //   }
  // }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailphoneController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Poppins(
                  text: 'Don’t have an account?',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Get.theme.hintColor,
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () => Get.to(SignupScreen(type: widget.type)),
                  child: Poppins(
                    text: 'Sign Up',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              child: Poppins(
                text: 'Sign in',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Get.theme.secondaryHeaderColor,
              ),
              onPressed: () => save(),
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
                height: Get.height * 0.4,
              ),
              Image.asset(Images.bglayer, width: Get.width, fit: BoxFit.cover),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.smalllogo, height: 90),
                  SizedBox(height: Get.height * 0.02),
                  Text(
                    'E-Learning',
                    style: GoogleFonts.prostoOne(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Poppins(
                    text: 'Hi, Welcome Back!',
                    fontSize: 20,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Poppins(
                    text: 'Sign in with your credentials',
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
                Poppins(
                  text: 'Email or mobile number',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Get.theme.secondaryHeaderColor,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Email address or mobile number',
                  controller: emailphoneController,
                ),
                SizedBox(height: 20),
                Poppins(
                  text: 'Password',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Get.theme.secondaryHeaderColor,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Password',
                  controller: passwordController,
                  suffixIcon: isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  obscureText: !isPasswordVisible,
                  onSuffixTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  onChanged: (value) {},
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(OtpVerificationScreen(
                        type: widget.type,
                        phNumber: emailphoneController.text,
                      ));
                    },
                    child: Poppins(
                      text: 'Forgot Password',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // Align(alignment: Alignment.center,
                //   child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8),),color: Get.theme.cardColor),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                //     child: IconButton(
                //       icon: Image.asset('assets/icons/google.png', width: 40, height: 40),
                //       onPressed: handleGoogleSignIn,
                //     ),
                //   ),
                // ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void save() {
    if (emailphoneController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    Get.find<AuthController>()
        .signIn(
      phone: emailphoneController.text,
      userPassword: passwordController.text,
      type: widget.type,
    )
        .then((value) {
      if (value.status == 200) {
        if (widget.type == "Student") {
          Get.off(() => StudentDashboard(index: 0));
        } else if (widget.type == "Teacher" || widget.type == "Tutor") {
          Get.off(() => TutorDashboard());
        }
      } else {
        // showCustomSnackBar(value.message ?? "Login failed", isError: true);
      }
    });
  }

  // void showCustomSnackBar(String message, {bool isError = false}) {
  //   Get.snackbar(
  //     isError ? "Error" : "Success",
  //     message,
  //     backgroundColor: isError ? Colors.redAccent : Colors.green,
  //     colorText: Colors.white,
  //     snackPosition: SnackPosition.BOTTOM,
  //     duration: Duration(seconds: 3),
  //     margin: EdgeInsets.all(12),
  //     borderRadius: 8,
  //   );
  // }
}
