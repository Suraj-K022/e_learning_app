import 'dart:io';
import 'package:e_learning_app/data/model/body/registerUserBody.dart';
import 'package:e_learning_app/utils/app_constants.dart';
import '/data/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<bool> saveUserToken(String token) async {
    try {
      apiClient.updateHeader(token);
      return await sharedPreferences.setString(AppConstants.token, token);
    } catch (e) {
      debugPrint("Error saving token: $e");
      return false;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    try {
      bool removed = await sharedPreferences.remove(AppConstants.token);
      if (removed) {
        apiClient.updateHeader(null);
      }
      return removed;
    } catch (e) {
      debugPrint("Error clearing shared data: $e");
      return false;
    }
  }

  Future<Response> loginUser(String phNumber, String password, String type) async {
    return await apiClient.postData(AppConstants.login, {"email_or_mobile": phNumber, "password": password, "type": type});
  }

  Future<Response> resetPassword(String email, String password, String confirmPassword, String token) async {
    return await apiClient.postData(AppConstants.resetPassword, {
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "token": token,
    });
  }

  Future<Response> forgotPassword(String email) async {
    return await apiClient.postData(AppConstants.forgotPassword, {"email": email});
  }

  Future<Response> registerUser(RegisterUserBody registerUserBody) async {
    return await apiClient.postData(AppConstants.signup, registerUserBody);
  }

  Future<Response> getProfile() async {
    return await apiClient.getData(AppConstants.profile);
  }

  Future<Response> getProfilePic() async {
    return await apiClient.getData(AppConstants.profileimage);
  }

  Future<Response> uploadProfilePic(File profileImg) async {
    List<MultipartBody> multipartBody = [];
    if (await profileImg.exists()) {
      multipartBody.add(MultipartBody('image', profileImg.path));
    }
    return await apiClient.postMultipartData(
      AppConstants.uploadprofileimage,
      body: {},
      multipartBody: multipartBody,
    );
  }

  Future<Response> updateProfile(String name, String email, String mobile) async {
    return await apiClient.postMultipartData(
      AppConstants.updateprofile,
      body: {
        "name": name,
        "email": email,
        "mobile": mobile,
      },
    );
  }
}
