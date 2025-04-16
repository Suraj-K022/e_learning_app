
import 'package:e_learning_app/controller/auth_controller.dart';
import 'package:e_learning_app/screens/Student/Student_Dashboard/StudentProfile/SettingScreen/setting_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddBannersScreen/add_banner_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddTestScreen/add_test_screen.dart';
import 'package:e_learning_app/screens/Tutor/Tutor_Dashboard/AddpdfScreen/add_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../customWidgets/customtext.dart';
import '../../../utils/images.dart';
import '../../Student/Student_Dashboard/StudentHome/NotificationScreen/notification_screen.dart';
import '../../Student/Student_Dashboard/StudentProfile/SettingScreen/ProfileScreen/profile_screen.dart';
import 'CoursesScreen/courses_screen.dart';
import 'CreateNewCourses/create_new_course.dart';
import 'PaymentScreen/payment_screen.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({super.key});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  @override
  void initState() {
    super.initState(); // Move this here

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title:


        GetBuilder<AuthController>(
          builder: (authController) {
            if (authController.isLoading) {
              return Poppins(text: 'Loading...',color: Get.theme.primaryColor,fontWeight: FontWeight.w400,fontSize: 12,);
            }

            else if (authController.profileModel?.username?.isEmpty ?? true) {
              return Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height/3,),
                  Center(child:
                  Poppins(text: 'Hey User, ',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.primaryColor,),

                  ),
                ],
              );
            }

            return


            Row(
              children: [
                InkWell(
                  onTap: () => Get.to(ProfileScreen()),
                  child: CircleAvatar(
                    backgroundColor: Get.theme.secondaryHeaderColor,
                    radius: 20,
                    backgroundImage: authController.profileModel?.image != null
                        ? NetworkImage(authController.profileModel!.image!)
                        : null,
                    child: authController.profileModel?.image == null
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),

                SizedBox(width: 10,),
                Poppins(text: 'Hey, ${authController.profileModel!.name.toString()} ',fontSize: 16,fontWeight: FontWeight.w500,color: Get.theme.primaryColor,),
              ],
            )
            ;

          },
        ),




        actions: [
          InkWell(onTap: (){Get.to(NotificationScreen());},child: Icon(Icons.notifications_active_outlined,size: 24,color: Get.theme.secondaryHeaderColor,)),
          SizedBox(width: 24,)],
      ),
      body: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 16,crossAxisSpacing: 16,childAspectRatio: 1/1),padding: EdgeInsets.symmetric(horizontal: 24,vertical: 24),children: [
        InkWell(onTap: (){Get.to(CreateNewCourse(courseName: '',ScreenName: 'TutorDashboard',));},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.add,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Create New Course',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),
        InkWell(onTap: (){Get.to(CoursesScreen());},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.course,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Courses',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),

        InkWell(onTap: (){Get.to(AddTestScreen());},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.test,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Test',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),
        InkWell(onTap: (){Get.to(PaymentScreen());},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.wallet,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Payments',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),

        InkWell(onTap: (){Get.to(AddPdfScreen());},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.settings,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Add Pdfs',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),
        // InkWell(onTap: (){Get.to(AddBannerScreen());},
        //   child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
        //     padding: const EdgeInsets.all(20),
        //     child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
        //       SizedBox(height: 30,width: 30,child: Image.asset(Images.settings,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
        //       Poppins(text: 'Add Banners',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
        //     ],),
        //   ),),
        // ),
        InkWell(onTap: (){Get.to(SettingScreen());},
          child: Container(decoration: BoxDecoration(color: Get.theme.cardColor,borderRadius: BorderRadius.all(Radius.circular(12),),border: Border.all(color: Get.theme.primaryColor,width: 1)),child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 5,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
              SizedBox(height: 30,width: 30,child: Image.asset(Images.settings,fit: BoxFit.cover,color: Get.theme.secondaryHeaderColor,),),
              Poppins(text: 'Settings',fontSize: 16,color: Get.theme.secondaryHeaderColor,fontWeight: FontWeight.w500,maxLines: 3,textAlign: TextAlign.center,)
            ],),
          ),),
        ),

      ],),
    );
  }
}
