import 'dart:io';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../CustomWidgets/custom_snackbar.dart';
import '../../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../../customWidgets/customtext.dart';

class EditScreen extends StatefulWidget {
  final String profileName;
  final String email;
  final String mobile;

  const EditScreen({
    super.key,
    required this.profileName,
    required this.email,
    required this.mobile,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profileName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.mobile);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Get.back(canPop: true),
          child: Icon(Icons.arrow_back_ios_new,
              color: Get.theme.secondaryHeaderColor, size: 24),
        ),
      ),
      bottomNavigationBar:
          GetBuilder<AuthController>(builder: (authController) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            child: Poppins(
              text: 'Save',
              color: Get.theme.secondaryHeaderColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            onPressed: () {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              final mobile = phoneController.text.trim();

              if (name.isEmpty || email.isEmpty || mobile.isEmpty) {
                showCustomSnackBar('All fields are required', isError: true);
                return;
              }

              if (name == widget.profileName &&
                  email == widget.email &&
                  mobile == widget.mobile) {
                showCustomSnackBar('You haven\'t made any changes.',
                    isError: true);
                return;
              }

              // Proceed with update
              authController
                  .updateProfile(
                name: name,
                email: email,
                mobile: mobile,
              )
                  .then((value) {
                if (value.status == 200) {
                  Get.find<AuthController>().getProfile();

                  Get.close(1);
                } else {
                  showCustomSnackBar(value.message, isError: true);
                }
              });
            },
          ),
        );
      }),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          Poppins(
            text: 'Edit your Profile',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 30),

          // Name Field
          Poppins(
            text: 'Edit Name',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter your name',
            controller: nameController,
          ),
          const SizedBox(height: 20),

          // Email Field
          Poppins(
            text: 'Edit Email',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter your email',
            controller: emailController,
          ),
          const SizedBox(height: 20),

          // Mobile Field
          Poppins(
            text: 'Edit Mobile',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Get.theme.secondaryHeaderColor,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter your mobile',
            controller: phoneController,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
