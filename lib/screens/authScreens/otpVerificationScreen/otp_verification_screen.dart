import 'package:e_learning_app/CustomWidgets/custom_snackbar.dart';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/screens/AuthScreens/SignInScreen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../customWidgets/Custom_input_text_field.dart';
import '../../../customWidgets/custom_buttons.dart';
import '../../../customWidgets/customtext.dart';
import '../../../utils/images.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String type;
  final String phNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phNumber,
    required this.type,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailphoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  bool _obscureConfirmPassword = true;
  bool isPasswordVisible = false;
  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? tokenError;

  int value = 0;

  void sendVerificationCode() {
    setState(() {
      emailError = emailphoneController.text.trim().isEmpty ? 'Field is required' : null;
    });

    if (emailError == null) {
      setState(() {
        isLoading = true;
      });

      Get.find<AuthController>()
          .forgotPassword(email: emailphoneController.text.trim())
          .then((response) {
        setState(() {
          isLoading = false;
        });

        if (response.status == 200) {
          setState(() {
            value = 1;
          });
        } else {
          showCustomSnackBar(response.message);
        }
      });
    }
  }

  void submit() {
    final emailOrPhone = emailphoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final token = tokenController.text.trim();

    setState(() {
      emailError = emailOrPhone.isEmpty ? 'Field is required' : null;

      passwordError = password.isEmpty
          ? 'Field is required'
          : password.length < 6
          ? 'Password must be at least 6 characters'
          : null;

      confirmPasswordError = confirmPassword != password
          ? 'Passwords do not match'
          : confirmPassword.isEmpty
          ? 'Field is required'
          : null;

      tokenError = token.isEmpty ? 'Field is required' : null;
    });

    if (emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        tokenError == null) {
      setState(() {
        isLoading = true;
      });

      Get.find<AuthController>()
          .resetPassword(
        email: emailOrPhone,
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      )
          .then((response) {
        setState(() {
          isLoading = false;
        });

        showCustomSnackBar(response.message);
        if (response.status == 200) {
          Get.off(SignInScreen(type: widget.type));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            value == 0 || value == 1
                ? CustomButton(
              onPressed: isLoading
                  ? null
                  : () => value == 0 ? sendVerificationCode() : submit(),
              child: isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Get.theme.scaffoldBackgroundColor,
                ),
              )
                  : Poppins(
                text: value == 0 ? 'Send Verification Code' : 'Submit ',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Get.theme.scaffoldBackgroundColor,
              ),
            )
                : SizedBox(),
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
                  Image.asset(
                    Images.smalllogo,
                    height: 90,
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
                    text: 'Forgot Password',
                    fontSize: 20,
                    color: Get.theme.secondaryHeaderColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Poppins(
                    text: 'We’ll send a code to your Gmail',
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
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Email address or mobile number',
                  controller: emailphoneController,
                  errorText: emailError,
                ),
                if (value == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Poppins(
                        text: 'Create New Password',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Enter Password',
                        controller: passwordController,
                        errorText: passwordError,
                        suffixIcon:
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        obscureText: !isPasswordVisible,
                        onSuffixTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Poppins(
                        text: 'Confirm Password',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        errorText: confirmPasswordError,
                      ),
                      const SizedBox(height: 20),
                      Poppins(
                        text: 'Paste Token Here',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Token from email',
                        controller: tokenController,
                        errorText: tokenError,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
