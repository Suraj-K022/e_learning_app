import 'package:e_learning_app/CustomWidgets/custom_snackbar.dart';
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../customWidgets/customtext.dart';
import 'EditProfileScreen/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    super.initState();
 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   Get.find<AuthController>().getProfile();
   Get.find<AuthController>().getProfilePic();
 },);
  }

  @override
  Widget build(BuildContext context) {
    return

    GetBuilder<AuthController>(builder: (authController) {
      return
        Scaffold(
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
              icon: Icon(Icons.arrow_back_ios, color: Get.theme.secondaryHeaderColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final profile = authController.profileModel!;
                  Get.to(() => EditScreen(
                    mobile: profile.mobile ?? '',
                    email: profile.email ?? '',
                    profileName: profile.name ?? '',
                  ));
                },
                icon: Icon(CupertinoIcons.pencil, size: 24, color: Get.theme.primaryColor),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: GetBuilder<AuthController>(
            builder: (authController) {
              if (authController.isLoading || authController.profileModel == null) {
                return Center(child: CircularProgressIndicator(color: Get.theme.primaryColor));
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
                            border: Border.all(color: Get.theme.primaryColor, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: profile.image != null && profile.image!.isNotEmpty
                                ? Image.network(profile.image!, fit: BoxFit.cover)
                                : Image.asset(Images.defaultAvatar, fit: BoxFit.cover),
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
    },);
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
