import 'package:e_learning_app/helper/get_di.dart';
import 'package:e_learning_app/screens/splashscreen/splash_screen.dart';
import 'package:e_learning_app/themedata/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/payment.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Optionally, navigate to an error screen or show a dialog.
  }
  await init();

  Get.put(ThemeController());
  Get.put(PaymentController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
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
