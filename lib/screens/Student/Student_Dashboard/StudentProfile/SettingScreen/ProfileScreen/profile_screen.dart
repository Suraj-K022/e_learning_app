import 'dart:io';
import 'package:e_learning_app/CustomWidgets/custom_snackbar.dart';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../customWidgets/customtext.dart';
import 'EditProfileScreen/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthController _authController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authController = Get.find<AuthController>();

    },);

    // Safe trigger for profile loading
    Future.delayed(Duration.zero, () {
      _authController.getProfile();
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final bytes = await file.length();

      const maxSizeInBytes = 2 * 1024 * 1024; // 2MB

      if (bytes > maxSizeInBytes) {
        showCustomSnackBar('"Image Too Large", "Please select an image smaller than 2MB."');
        return;
      }

      setState(() {});
      await _uploadImage(file);
    }
  }


  Future<void> _uploadImage(File imageFile) async {
    final controller = Get.find<AuthController>();
    final result = await controller.updateProfilePic(profileImg: imageFile);
    if (result.status == 200) {
      Get.find<AuthController>().getProfilePic();
      Get.snackbar("Success", "Profile picture uploaded successfully.");
    } else {
      Get.snackbar("Error", result.message);
    }
  }

  void _showEditImageBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: Get.theme.secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Poppins(
                        text: 'You can update this only once',
                        color: Get.theme.secondaryHeaderColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      Poppins(
                        text:
                            "Make sure you give your best shot, since you won't be able to change this later.",
                        color: Get.theme.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    Images.logout,
                    height: 64,
                    width: 64,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Get.theme.secondaryHeaderColor),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Poppins(
                          text: 'Cancel',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Get.theme.canvasColor),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Poppins(
                          text: 'Continue',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Get.theme.canvasColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Profile',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon:
              Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final profile = _authController.profileModel!;
              Get.to(() => EditScreen(
                    mobile: profile.mobile ?? '',
                    email: profile.email ?? '',
                    profileName: profile.name ?? '',
                  ));
            },
            icon: Icon(CupertinoIcons.pencil,
                size: 24, color: Get.theme.primaryColor),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          if (authController.isLoading || authController.profileModel == null) {
            return Center(
                child:
                    CircularProgressIndicator(color: Get.theme.primaryColor));
          }

          final profile = authController.profileModel!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 38),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: Get.width * 0.3,
                      height: Get.width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Get.theme.primaryColor, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profile.image != null &&
                                profile.image!.isNotEmpty
                            ? Image.network(profile.image!, fit: BoxFit.cover)
                            : Image.asset(Images.defaultAvatar,
                                fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _showEditImageBottomSheet,
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
              _buildListTile('Name', profile.name),
              _buildListTile('Email address', profile.email),
              _buildListTile('Mobile number', '+91 ${profile.mobile}'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile(String title, String? subtitle) {
    return Column(
      children: [
        ListTile(
          tileColor: Get.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Poppins(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Get.theme.hintColor,
          ),
          subtitle: Poppins(
            text: subtitle ?? '',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Get.theme.secondaryHeaderColor,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
