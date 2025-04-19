import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../data/repository/coursee_repo.dart';
import '../controller/auth_controller.dart';
import '../controller/course_Controller.dart';
import '../data/repository/auth_repo.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(sharedPreferences: Get.find()));

  // Repository dependencies
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CourseRepo(
        apiClient: Get.find(),
      ));
  Get.lazyPut(() => ApiClient(sharedPreferences: Get.find()));

  // Get.lazyPut(() => VehicleRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controller dependencies
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => CourseController(courseRepo: Get.find()));
  Get.lazyPut(() => CourseRepo(apiClient: Get.find()));
  // Get.lazyPut(() => VehicleController(vehicleRepo: Get.find()));
  // Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  // Get.lazyPut(() => OrderController(orderRepo: Get.find()));
}
