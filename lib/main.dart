
import 'package:e_learning_app/helper/get_di.dart';
import 'package:e_learning_app/screens/splashscreen/splash_screen.dart';
import 'package:e_learning_app/themedata/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'controller/payment.dart';



void main() async{
 await init();
  Get.put(ThemeController()); // Initialize the controller
  Get.put(PaymentController()); // Ensure controller is initialized globally
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme, // Default theme
        darkTheme: darkTheme,
        themeMode: ThemeMode.light, // Default mode
        builder: (context, child) {
          return Obx(() {
            return Theme(
              data: themeController.isDarkMode.value ? darkTheme : lightTheme,
              child: child!,
            );
          });
        },
        home: SplashScreen(),
      );
  }
}
