import 'dart:developer';
import 'dart:io';

import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import "package:flutter/material.dart";

class CourseRepo{
  final ApiClient apiClient;
  CourseRepo( {
    required this.apiClient,

  });

  Future getAllCourse() async {
    try {
      return await apiClient.getData(AppConstants.allcourses);
    } catch (e,straktrace) {
      debugPrint("Error fetching All Courses: $e $straktrace");
      rethrow;
    }
  }
  Future getAllTestSeries() async {
    try {
      return await apiClient.getData(AppConstants.gettestseries);
    } catch (e,straktrace) {
      debugPrint("Error fetching All Courses: $e $straktrace");
      rethrow;
    }
  }



  Future getMcqQuestions() async {
    try {
      return await apiClient.getData(AppConstants.questions);
    } catch (e,straktrace) {
      debugPrint("Error fetching All Courses: $e $straktrace");
      rethrow;
    }
  }
  Future getPdfNotes() async {
    try {
      return await apiClient.getData(AppConstants.getpdfnotes);
    } catch (e,straktrace) {
      debugPrint("Error fetching All Courses: $e $straktrace");
      rethrow;
    }
  }




  Future getAllContent({required String id}) async {
    try {
      return await apiClient.getData("${AppConstants.allcontent}?id=$id}");
    } catch (e,straktrace) {
      debugPrint("Error fetching All Content: $e $straktrace");
      rethrow;
    }
  }



  Future getBanner() async {
    try {
      return await apiClient.getData(AppConstants.getbanner);
    } catch (e,straktrace) {
      debugPrint("Error fetching All Content: $e $straktrace");
      rethrow;
    }
  }



  Future<Response> addCourse( String coursename, List thumbnailImg,) async {
    List<MultipartBody> collection=[];

    for (var item in thumbnailImg) {
      collection.add(MultipartBody("course_image", item)); // Do something with each item
    }

    try {
      return await apiClient.postMultipartData(AppConstants.addcourse,
          body: {
        "course_name":coursename
          },
          multipartBody: collection);
    } catch (e) {
      debugPrint("Error adding course & thumbnail: $e");
      rethrow;
    }
  }
  Future<Response> addTest( String testName, List thumbnailImg,) async {
    List<MultipartBody> collection=[];
    for (var item in thumbnailImg) {
      collection.add(MultipartBody("image", item)); // Do something with each item
    }
    try {
      return await apiClient.postMultipartData(AppConstants.testseries,
          body: {
        "title":testName
          },
          multipartBody: collection);
    } catch (e) {
      debugPrint("Error adding course & thumbnail: $e");
      rethrow;
    }
  }



  Future<Response> addContent(
      String course,
      String title,
      String description,
      File? contentImg,
      File? contentVideo,
      File? contentPdf,
      ) async {
    try {
      List<MultipartBody> multipartBody = [];

      if (contentImg != null && await contentImg.exists()) {
        multipartBody.add(MultipartBody('content_image', contentImg.path));
      }

      if (contentVideo != null && await contentVideo.exists()) {
        multipartBody.add(MultipartBody('vedio_upload', contentVideo.path));
      }

      if (contentPdf != null && await contentPdf.exists()) {
        multipartBody.add(MultipartBody('pdf_upload', contentPdf.path));
      }

      log("Prepared Multipart Files: $multipartBody");

      return await apiClient.postMultipartData(
        AppConstants.addcontent,
        body: {
          "course": course,
          "title": title,
          "description": description,
        },
        multipartBody: multipartBody,
      );
    } catch (e) {
      debugPrint("Error adding content: $e");
      rethrow;
    }
  }








  Future<Response> addPdfs(
      String course,
      File? contentImg,
      File? contentPdf,
      ) async {
    try {
      List<MultipartBody> multipartBody = [];

      if (contentImg != null && await contentImg.exists()) {
        multipartBody.add(MultipartBody('image', contentImg.path));
      }


      if (contentPdf != null && await contentPdf.exists()) {
        multipartBody.add(MultipartBody('pdf', contentPdf.path));
      }

      log("Prepared Multipart Files: $multipartBody");

      return await apiClient.postMultipartData(
        AppConstants.addpdfnote,
        body: {
          "name": course,
        },
        multipartBody: multipartBody,
      );
    } catch (e) {
      debugPrint("Error adding content: $e");
      rethrow;
    }
  }







  Future<Response> addBanners(
      File? contentImg,

      ) async {
    try {
      List<MultipartBody> multipartBody = [];

      if (contentImg != null && await contentImg.exists()) {
        multipartBody.add(MultipartBody('data[]', contentImg.path));
      }



      log("Prepared Multipart Files: $multipartBody");

      return await apiClient.postMultipartData(
        AppConstants.uploadbanner,
        body: {},
        multipartBody: multipartBody,
      );
    } catch (e) {
      debugPrint("Error adding content: $e");
      rethrow;
    }
  }




  Future deleteContent(int contentId) async {
    try {
      return await apiClient.deleteData("${AppConstants.deletecontent}$contentId");
    } catch (e,straktrace) {
      debugPrint("Error fetching Profile: $e $straktrace");
      rethrow;
    }
  }



















}