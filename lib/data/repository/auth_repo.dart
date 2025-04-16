

import 'dart:developer';
import 'dart:io';

import 'package:e_learning_app/data/model/body/registerUserBody.dart';
import 'package:e_learning_app/utils/app_constants.dart';

import '/data/api/api_client.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo( {
    required this.apiClient,required this.sharedPreferences,

});
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

  // Save dark mode preference
  void saveThemeMode(bool isDarkMode) {
    sharedPreferences.setBool(AppConstants.themeMode, isDarkMode);
  }

// Load dark mode preference (default to false/light)
  bool loadThemeMode() {
    return sharedPreferences.getBool(AppConstants.themeMode) ?? false;
  }



  Future<Response> loginUser( String phNumber, String password,String type) async {
    try {
      return await apiClient.postData(AppConstants.login, {"email_or_mobile": phNumber,"password": password,"type":type});
    } catch (e) {
      debugPrint("Error sending phone number & pass: $e");
      rethrow;
    }
  }
//sign up data
  Future<Response> registerUser(RegisterUserBody registerUserBody) async {
    try {
      return await apiClient.postData(AppConstants.signup, registerUserBody);
    } catch (e) {
      debugPrint("Error sending phone number & pass: $e");
      rethrow;
    }
  }


  Future getProfile() async {
    try {
      return await apiClient.getData(AppConstants.profile);
    } catch (e,straktrace) {
      debugPrint("Error fetching Profile: $e $straktrace");
      rethrow;
    }
  }
  Future getProfilePic() async {
    try {
      return await apiClient.getData(AppConstants.profileimage);
    } catch (e,straktrace) {
      debugPrint("Error fetching Profile: $e $straktrace");
      rethrow;
    }
  }
  Future deleteProfile(int userId) async {
    try {
      return await apiClient.deleteData("${AppConstants.deleteUser}$userId");
    } catch (e,straktrace) {
      debugPrint("Error fetching Profile: $e $straktrace");
      rethrow;
    }
  }


  Future<Response> uploadProfilePic(
      File? profileImg,
      ) async {
    try {
      List<MultipartBody> multipartBody = [];
      if (profileImg != null && await profileImg.exists()) {
        multipartBody.add(MultipartBody('image', profileImg.path));
      }
      log("Prepared Multipart Files: $multipartBody");
      return await apiClient.postMultipartData(
        AppConstants.uploadprofileimage,
        body: {},
        multipartBody: multipartBody,
      );
    } catch (e) {
      debugPrint("Error adding content: $e");
      rethrow;
    }
  }



  Future<Response> updateProfile(
      String name,
      String email,
      String mobile,
      ) async {
    try {
      return await apiClient.postMultipartData(
        AppConstants.updateprofile,
        body: {
          "name": name,
          "email": email,
          "mobile": mobile,
        },
      );
    } catch (e) {
      debugPrint("Error adding content: $e");
      rethrow;
    }
  }




}