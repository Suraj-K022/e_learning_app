
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../customWidgets/customtext.dart';
import '../../../utils/images.dart';
import '../../AuthScreens/SignInScreen/sign_in_screen.dart';


class EntityScreen extends StatefulWidget {
  const EntityScreen({super.key});

  @override
  State<EntityScreen> createState() => _EntityScreenState();
}

class _EntityScreenState extends State<EntityScreen> {
  String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 140,
          ),
          SizedBox(
            height: 104,
            width: 123,
            child: Image.asset(Images.logo),
          ),
          SizedBox(
            height: 40,
          ),
          Poppins(text:
            'Join as a',
            color: Get.theme.secondaryHeaderColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: Get.theme.hintColor.withOpacity(0.2))),
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        type="Student";

                      });

                      Get.to(()=>SignInScreen(type: type.toString(),));

                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                        child: Poppins(text:
                          'Student',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    )),
                InkWell(
                    onTap: () {


                      setState(() {
                        type="Tutor";

                      });
                      Get.to(()=>SignInScreen(type: type.toString(),));



                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                        child: Poppins(text:
                          'Tutor ',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    )),

              ],
            ),
          )
        ],
      ),
    );
  }
}
