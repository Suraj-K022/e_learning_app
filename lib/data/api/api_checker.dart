import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';

import '../../CustomWidgets/custom_snackbar.dart';

import '../../controller/auth_controller.dart';
import '../../screens/splashscreen/splash_screen.dart';
import '../model/base/response_model.dart';

Future<ResponseModel> checkResponseModel(Response response) async {
  log(response.statusCode.toString());
  log(response.statusText.toString());
  log(json.encode(response.body));
  if (response.statusCode == 401) {
    await Get.find<AuthController>().clearSharedData();
    Get.offAll(() => const SplashScreen());
    showCustomSnackBar('Auth Failed', isError:
    true);
    return ResponseModel(401, 'Unauthorized', null);
  }
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (response.body['status'] == 200) {
      return ResponseModel(response.body['status'],
          response.body['message'] ?? '', response.body['data']);
    } else {
      return ResponseModel(
          response.body['status'], response.body['message'] ?? '', null);
    }


  }
  if(response.statusCode == 400){
    return ResponseModel(response.body['status'],
        response.body['message'] ?? '', response.body['data']);
  }
  else {
    if (!response.body.toString().startsWith('{')) {
      showCustomSnackBar('Internal Server Error :${response.statusCode}',
          isError: true);
      return ResponseModel(500, 'Internal Server Error', null);
    } else {
      return ResponseModel(
          response.body['status'], response.body['message'], null);
    }
  }
}
