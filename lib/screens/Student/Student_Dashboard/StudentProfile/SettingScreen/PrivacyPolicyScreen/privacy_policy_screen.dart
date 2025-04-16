import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../customWidgets/customtext.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Privacy Policy',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () {
            Get.back(canPop: true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),

      ),
      body: ListView(padding: EdgeInsets.symmetric(horizontal: 24),
        children: [


          SizedBox(height: Get.height/3,),
          Poppins(text: 'Nothing to Show',fontWeight: FontWeight.w600,fontSize: 20,color: Get.theme.hintColor,textAlign: TextAlign.center,)
        ],),
    );
  }
}
