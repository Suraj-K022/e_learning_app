import 'package:e_learning_app/screens/splashscreen/entityScreen/entity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../CustomWidgets/custom_snackbar.dart';
import '../../../../../../controller/auth_controller.dart';
import '../../../../../../customWidgets/Custom_input_text_field.dart';
import '../../../../../../customWidgets/custom_buttons.dart';
import '../../../../../../customWidgets/custom_check_box.dart';
import '../../../../../../customWidgets/customtext.dart';
import '../../../../../AuthScreens/SignInScreen/sign_in_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AuthController>().getProfile();

    },);
  }

  final TextEditingController reasonController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Delete Account',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios,
              color: Get.theme.secondaryHeaderColor, size: 24),
        ),
      ),
      body: GetBuilder<AuthController>(builder: (_) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: Get.height / 20),
            Poppins(
              text: 'Permanently delete your E Learning account',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Get.theme.secondaryHeaderColor,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Poppins(
              text: 'Please specify a reason (max 200 characters)',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Get.theme.hintColor,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'Type here...',
              maxLines: 10,
              controller: reasonController,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_alt_outlined,
                      color: Get.theme.hintColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Poppins(
                      text:
                          'Please note that this action is irreversible. You will not be able to use the app.',
                      maxLines: 4,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Get.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckBox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Poppins(
                    text:
                        'I understand that this action is irreversible and all my data will be permanently deleted.',
                    maxLines: 4,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Get.theme.secondaryHeaderColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              child: Poppins(
                text: 'Delete now',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Get.theme.scaffoldBackgroundColor,
              ),
              onPressed: () async {
                if (!isChecked) {
                  showCustomSnackBar(
                      "Please confirm before deleting your account.");
                  return;
                }

                int userId =
                    int.parse(authController.profileModel!.id.toString());
                await authController.deleteProfile(userId).then((value) {
                  if (value.status == 200) {
                    Get.offAll(EntityScreen());
                  } else {
                    showCustomSnackBar(value.message, isError: true);
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            Poppins(
              text: 'You\'ll be redirected to log-in for security reasons.',
              maxLines: 4,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.theme.hintColor,
            )
          ],
        );
      }),
    );
  }
}
