import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:e_learning_app/data/model/base/response_model.dart';
import 'package:e_learning_app/data/model/response/profileModel.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../data/model/body/registerUserBody.dart';
import '../data/repository/auth_repo.dart';

import '../CustomWidgets/custom_snackbar.dart';
import '../data/api/api_checker.dart';
import '../utils/app_constants.dart';

class AuthController extends GetxController with GetxServiceMixin {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  String? userId;
  bool isLoading = false;
  ProfileModel? profileModel;
  String? profilePic;

  /// Checks if the user is logged in
  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  /// Clears shared data (logout function)
  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  /// Retrieves the user's authentication token
  String getUserToken() {
    return authRepo.getUserToken();
  }

  /// Sends phone number to the API for authentication
  Future<ResponseModel> signIn(
      {required String phone,
      required String userPassword,
      required String type}) async {
    update();
    Response response = await authRepo.loginUser(phone, userPassword, type);

    log("jjoj" + jsonEncode(response.statusCode)); // Logs response status code

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {
      authRepo.saveUserToken(response.body["token"]);
    }

    update();
    return responseModel;
  }


  Future<ResponseModel> resetPassword(
      {required String email,
      required String password,
      required String confirmPassword,
      required String token,

      }) async {
    update();
    Response response = await authRepo.resetPassword(email,password,confirmPassword,token);

    log("jjoj" + jsonEncode(response.statusCode)); // Logs response status code

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message, isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {
      // authRepo.saveUserToken(response.body["token"]);
    }

    update();
    return responseModel;
  }

  Future<ResponseModel> forgotPassword(
      {required String email,}) async {
    update();
    Response response = await authRepo.forgotPassword(email);

    log("jjoj" + jsonEncode(response.statusCode)); // Logs response status code

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {
      // authRepo.saveUserToken(response.body["token"]);
    }

    update();
    return responseModel;
  }

  Future<ResponseModel> signUp(
      {required RegisterUserBody registerUserBody}) async {
    // isLoading=true;

    update();
    Response response = await authRepo.registerUser(registerUserBody);

    log("jjoj" + jsonEncode(response.statusCode));

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {
    } else {
      // showCustomSnackBar(responseModel.message);
    }
    // isLoading=false;

    update();

    return responseModel;
  }

  Future<ResponseModel> getProfile() async {
    isLoading = true;
    update();

    Response response = await authRepo.getProfile();
    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      profileModel = profileModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getProfilePic() async {
    isLoading = true;
    update();

    Response response = await authRepo.getProfilePic();
    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      profilePic = responseModel.data['image'];
    }


    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateProfilePic({required File profileImg}) async {
    update();
    Response response = await authRepo.uploadProfilePic(profileImg);
    log("profile pic update: ${jsonEncode(response.body)}");
    ResponseModel responseModel = await checkResponseModel(response);
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);
    if (responseModel.status == 200) {}
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteProfile(int userId) async {
    try {
      Response response = await authRepo.apiClient
          .deleteData("${AppConstants.deleteUser}$userId");

      ResponseModel responseModel = await checkResponseModel(response);

      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );

      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }



  Future<ResponseModel> updateProfile({
    required String name,
    required String email,
    required String mobile,
  }) async {
    update();
    Response response = await authRepo.updateProfile(name, email, mobile);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    update();
    return responseModel;
  }
}
