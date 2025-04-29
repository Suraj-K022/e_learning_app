import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:e_learning_app/data/model/base/response_model.dart';
import 'package:e_learning_app/data/model/response/profileModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

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

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  Future<ResponseModel> signIn({required String phone, required String userPassword, required String type}) async {
    update();
    Response response = await authRepo.loginUser(phone, userPassword, type);
    ResponseModel responseModel = await checkResponseModel(response);

    if (responseModel.status == 200) {
      authRepo.saveUserToken(response.body["token"]);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    update();
    Response response = await authRepo.resetPassword(email, password, confirmPassword, token);
    ResponseModel responseModel = await checkResponseModel(response);
    update();
    return responseModel;
  }

  Future<ResponseModel> forgotPassword({required String email}) async {
    update();
    Response response = await authRepo.forgotPassword(email);
    ResponseModel responseModel = await checkResponseModel(response);
    update();
    return responseModel;
  }

  Future<ResponseModel> signUp({required RegisterUserBody registerUserBody}) async {
    update();
    Response response = await authRepo.registerUser(registerUserBody);
    ResponseModel responseModel = await checkResponseModel(response);
    update();
    return responseModel;
  }

  Future<ResponseModel> getProfile() async {
    isLoading = true;
    update();

    Response response = await authRepo.getProfile();
    ResponseModel responseModel = await checkResponseModel(response);

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
    ResponseModel responseModel = await checkResponseModel(response);
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteProfile(int userId) async {
    try {
      Response response = await authRepo.apiClient.deleteData("${AppConstants.deleteUser}$userId");
      ResponseModel responseModel = await checkResponseModel(response);
      return responseModel;
    } catch (e) {
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
    ResponseModel responseModel = await checkResponseModel(response);
    update();
    return responseModel;
  }
}
