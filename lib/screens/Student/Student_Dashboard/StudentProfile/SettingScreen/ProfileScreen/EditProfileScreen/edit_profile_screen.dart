import 'dart:io';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../CustomWidgets/custom_snackbar.dart';
import '../../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../../customWidgets/customtext.dart';
import '../../../../../../../utils/images.dart';

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
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final bytes = await file.length();
      const maxSizeInBytes = 2 * 1024 * 1024;

      if (bytes > maxSizeInBytes) {
        showCustomSnackBar('Image Too Large. Please select an image smaller than 2MB.');
        return;
      }

      setState(() {
        _pickedImage = file;
      });

      await _uploadImage(file);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final controller = Get.find<AuthController>();
    final result = await controller.updateProfilePic(profileImg: imageFile);
    if (result.status == 200) {
      controller.getProfilePic();
      Get.snackbar("Success", "Profile picture uploaded successfully.");
    } else {
      Get.snackbar("Error", result.message);
    }
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
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title:
        Poppins(
          text: 'Edit your Profile',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        centerTitle: true,

        backgroundColor: Get.theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () async {
            final authController = Get.find<AuthController>();
            await authController.getProfile(); // Await the API call
            Get.back(); // Navigate back after the call completes
          },
          child: Icon(Icons.arrow_back_ios_new, color: Get.theme.secondaryHeaderColor, size: 24),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          child: Poppins(
            text: 'Save',
            color: Get.theme.scaffoldBackgroundColor,
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
              showCustomSnackBar('You haven\'t made any changes.', isError: true);
              return;
            }

            authController.updateProfile(name: name, email: email, mobile: mobile).then((value) {
              if (value.status == 200) {
                authController.getProfile();
                Get.back();
              } else {
                showCustomSnackBar(value.message, isError: true);
              }
            });
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                GetBuilder<AuthController>(builder: (controller) {
                  final image = _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : controller.profileModel?.image != null &&
                      controller.profileModel!.image!.isNotEmpty
                      ? NetworkImage(controller.profileModel!.image!)
                      : AssetImage(Images.defaultAvatar) as ImageProvider;

                  return Container(
                    width: Get.width * 0.3,
                    height: Get.width * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Get.theme.primaryColor, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(image: image, fit: BoxFit.cover),
                    ),
                  );
                }),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Get.theme.primaryColor),
                      ),
                      child: Icon(CupertinoIcons.pencil,
                          size: 20, color: Get.theme.secondaryHeaderColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Poppins(text: 'Edit Name', fontWeight: FontWeight.w500, fontSize: 16, color: Get.theme.secondaryHeaderColor),
          const SizedBox(height: 8),
          CustomTextField(hintText: 'Enter your name', controller: nameController),
          const SizedBox(height: 20),
          Poppins(text: 'Edit Email', fontWeight: FontWeight.w500, fontSize: 16, color: Get.theme.secondaryHeaderColor),
          const SizedBox(height: 8),
          CustomTextField(hintText: 'Enter your email', controller: emailController),
          const SizedBox(height: 20),
          Poppins(text: 'Edit Mobile', fontWeight: FontWeight.w500, fontSize: 16, color: Get.theme.secondaryHeaderColor),
          const SizedBox(height: 8),
          CustomTextField(hintText: 'Enter your mobile', controller: phoneController),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
