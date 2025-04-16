
import 'package:e_learning_app/screens/splashscreen/entityScreen/entity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/auth_controller.dart';
import '../../../../../customWidgets/customtext.dart';
import '../../../../../utils/images.dart';

import '../../../../AuthScreens/SignInScreen/sign_in_screen.dart';
import 'DeleteAccountScreen/delete_account_screen.dart';
import 'PrivacyPolicyScreen/privacy_policy_screen.dart';
import 'ProfileScreen/profile_screen.dart';
import 'ReportProblemScreen/report_problem_screen.dart';
import 'TermsAndConditionScreen/terms_and_condition_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Settings',
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

body:
ListView(
  padding: EdgeInsets.symmetric(horizontal: 24),
  children: [
Poppins(text: 'My Account',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.secondaryHeaderColor,),
    SizedBox(height: 8,),
    
    ListTile(onTap: (){Get.to(ProfileScreen());},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s1,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(text: 'Profile',fontWeight: FontWeight.w400,color: Get.theme.secondaryHeaderColor,fontSize: 14,),
      trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Get.theme.secondaryHeaderColor,),),
    SizedBox(height: 10,),
    Poppins(text: 'Feedback',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.secondaryHeaderColor,),
    SizedBox(height: 8,),
    ListTile(onTap: (){},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s2,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(text: 'Rate the app',fontWeight: FontWeight.w400,color: Get.theme.secondaryHeaderColor,fontSize: 14,),
      trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Get.theme.secondaryHeaderColor,),),
    SizedBox(height: 10,),
    ListTile(onTap: (){Get.to(ReportProblemScreen());},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s3,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(text: 'Report a Problem',fontWeight: FontWeight.w400,color: Get.theme.secondaryHeaderColor,fontSize: 14,),
      trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Get.theme.secondaryHeaderColor,),),
    SizedBox(height: 10,),


    Poppins(text: 'E Learning',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.secondaryHeaderColor,),
    SizedBox(height: 8,),
    ListTile(onTap: (){Get.to(TermsAndConditionScreen());},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s4,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(text: 'Terms and conditions',fontWeight: FontWeight.w400,color: Get.theme.secondaryHeaderColor,fontSize: 14,),
      trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Get.theme.secondaryHeaderColor,),),
    SizedBox(height: 10,),
    ListTile(onTap: (){Get.to(PrivacyPolicyScreen());},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s5,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(text: 'Privacy policy',fontWeight: FontWeight.w400,color: Get.theme.secondaryHeaderColor,fontSize: 14,),
      trailing: Icon(Icons.arrow_forward_ios,size: 20,color: Get.theme.secondaryHeaderColor,),),
    SizedBox(height: 10,),




    Poppins(text: 'System',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.secondaryHeaderColor,),
    SizedBox(height: 8,),
    ListTile(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(alignment: Alignment.center,child: Container(width: 20,height: 3,decoration: BoxDecoration(color: Get.theme.secondaryHeaderColor,borderRadius: BorderRadius.all(Radius.circular(3))),)),
                SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(flex: 4,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(text: 'Are You Sure? ',color: Get.theme.secondaryHeaderColor,fontSize: 16,fontWeight: FontWeight.w500,),
                          Poppins(text: 'If you want to sign in again, you\'ll need an OTP from your mobile number or Email.',color: Get.theme.hintColor,fontSize: 12,fontWeight: FontWeight.w500,maxLines: 3,),
                        ],
                      ),
                    ),
                    Expanded(flex: 1,child: Image.asset(Images.logout,height: 64,width: 64,))

                    
                  ],
                ),
                SizedBox(height: 20,),


                Row(spacing: 20,children: [
                  Expanded(flex: 1,child: InkWell(onTap: (){Get.back(canPop: true);},child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(width: 1,color: Get.theme.secondaryHeaderColor)),padding: EdgeInsets.symmetric(vertical: 10),child: Center(child: Poppins(text: 'Back',fontWeight: FontWeight.w500,fontSize: 16,color: Get.theme.secondaryHeaderColor,),),))),
                  Expanded(flex: 1,child: InkWell(onTap: (){



                    Get.find<AuthController>().clearSharedData().then((value) {
                      Get.offAll(EntityScreen());

                    },);


                    },child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(width: 1,color: Get.theme.canvasColor)),padding: EdgeInsets.symmetric(vertical: 10),child: Center(child: Poppins(text: 'Sign Out',fontWeight: FontWeight.w500,fontSize: 16,color: Get.theme.canvasColor,),),))),

                ],)


              ],
            ),
          ),
          backgroundColor: Get.theme.scaffoldBackgroundColor, // Matches theme
          isDismissible: true, // Allows user to swipe down to close
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      tileColor: Get.theme.cardColor,
      leading: Image.asset(Images.s6,width: 24,height: 24,fit: BoxFit.cover,),
      title: Poppins(
        text: 'Sign out',
        fontWeight: FontWeight.w400,
        color: Get.theme.secondaryHeaderColor,
        fontSize: 14,
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Get.theme.secondaryHeaderColor),
    ),

    SizedBox(height: 10,),
    ListTile(onTap: (){Get.to(DeleteAccountScreen());},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),tileColor: Get.theme.cardColor,
      title: Poppins(text: 'Delete Account',fontWeight: FontWeight.w400,color: Get.theme.canvasColor,fontSize: 14,),
    ),
    SizedBox(height: 10,),


  ],
),

    );
  }
}
