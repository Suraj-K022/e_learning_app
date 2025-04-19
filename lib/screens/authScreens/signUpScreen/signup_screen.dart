import 'package:e_learning_app/screens/AuthScreens/SignInScreen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../CustomWidgets/custom_snackbar.dart';
import '../../../controller/auth_controller.dart';
import '../../../customWidgets/Custom_input_text_field.dart';
import '../../../customWidgets/custom_buttons.dart';
import '../../../customWidgets/customtext.dart';
import '../../../data/model/body/registerUserBody.dart';
import '../../../utils/images.dart';


class SignupScreen extends StatefulWidget {
  final String type;
  const SignupScreen({super.key, required this.type});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void save() {
    final registerUserBody = RegisterUserBody(
      name: fullnameController.text,
      email: emailController.text,
      mobile: phoneController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      type: widget.type,
    );

    Get.find<AuthController>()
        .signUp(registerUserBody: registerUserBody)
        .then((value) {
      if (value.status == 200) {
        if (widget.type == "Student") {
          Get.off(() => SignInScreen(type: widget.type));
        } else {
          Get.off(() => SignInScreen(type: widget.type));
        }
      } else {
        showCustomSnackBar(value.message, isError: true);
      }
    });
  }

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
                  text: 'Already have an account?',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Get.theme.hintColor,
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () => Get.back(),
                  child: Poppins(
                    text: 'Sign In',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: save,
              child: Poppins(
                text: 'Sign Up',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Get.theme.secondaryHeaderColor,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                    color: Get.theme.primaryColor,
                  ),
                  height: Get.height * 0.4,
                ),
                Image.asset(Images.bglayer,
                    width: Get.width, fit: BoxFit.cover),
                Column(
                  children: [
                    SizedBox(height: 60),
                    Image.asset(Images.smalllogo, height: 90),
                    SizedBox(height: Get.height * 0.02),
                    Poppins(
                      text: 'E-Learning',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Poppins(
                      text: 'Create Account',
                      fontSize: 20,
                      color: Get.theme.secondaryHeaderColor,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: Get.height * 0.015),
                    Poppins(
                      text: 'Register with Email or Phone Number',
                      fontSize: 16,
                      color: Get.theme.secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  buildLabel('Full Name'),
                  CustomTextField(
                    hintText: 'Enter your full name',
                    controller: fullnameController,
                  ),
                  SizedBox(height: 20),
                  buildLabel('Mobile Number'),
                  CustomTextField(
                    hintText: 'Enter Mobile Number',
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxDigits: 10,
                  ),
                  SizedBox(height: 20),
                  buildLabel('Email Address'),
                  CustomTextField(
                    hintText: 'Enter Email Address',
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  buildLabel('Password'),
                  CustomTextField(
                    hintText: 'Enter Password',
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20),
                  buildLabel('Confirm Password'),
                  CustomTextField(
                    hintText: 'Confirm Password',
                    controller: _confirmPasswordController,
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Text.rich(
                    TextSpan(
                      text: 'By signing up you accept the ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(String text) {
    return Poppins(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Get.theme.secondaryHeaderColor,
    );
  }
}
