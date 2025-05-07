import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_learning_app/data/model/response/allContentModel.dart';
import 'package:e_learning_app/data/model/response/mcqModel.dart';
import 'package:e_learning_app/data/model/response/paidCourseContentsModel.dart';
import 'package:e_learning_app/data/model/response/paidCoursesModel.dart';
import 'package:e_learning_app/data/model/response/pdfnotesModel.dart';
import 'package:e_learning_app/data/model/response/privacyPolicyModel.dart';
import 'package:e_learning_app/data/model/response/termsConditionModel.dart';
import 'package:e_learning_app/data/model/response/testSeriesModel.dart';
import 'package:e_learning_app/data/repository/coursee_repo.dart';
import 'package:get/get.dart';

import '../CustomWidgets/custom_snackbar.dart';
import '../data/model/response/allCourseModel.dart';
import '../data/api/api_checker.dart';
import '../data/model/base/response_model.dart';
import '../data/model/response/transactionDetailModel.dart';
import '../utils/app_constants.dart';

class CourseController extends GetxController with GetxServiceMixin {
  final CourseRepo courseRepo;

  CourseController({required this.courseRepo});

  bool isLoading = false;

  List<AllCourses> _allCourses = [];
  List<TestSeriesModel> allTestSeries = [];
  List<PdfNotesModel> getpdfNotes = [];
  List<McqModel> getQuestions = [];
  List<TermsConditionModel> getTermsCondition = [];
  List<PrivacyPolicyModel> getPrivacyPolicy = [];
  List<AllContentModel>? allContentList=[];
  List getBannerList = [];
  List<AllCourses> filteredCourses = [];
  List<AllCourses> get getCourseList => filteredCourses;
  List<PaidCoursesModel> myPaidCourses = [];
  List<PaidCoursesContentsModel> paidCourseContents = [];
  List<TransactionDetailsModel> getTransactionDetails = [];

  Future<ResponseModel> getAllCourses() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getAllCourse();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      _allCourses = allCoursesFromJson(jsonEncode(responseModel.data));
      filteredCourses = _allCourses; // Initially show all
    }

    isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> getAllTestSeries() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getAllTestSeries();
    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      allTestSeries = testSeriesModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getTermsAndCondition() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getTermsCondition();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      getTermsCondition =
          termsConditionModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getPolicy() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getPrivacyPolicy();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      getPrivacyPolicy =
          privacyPolicyModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getAllTransactions() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getAllTransactions();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      getTransactionDetails =
          transactionDetailsModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getPdfNotes() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getPdfNotes();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      getpdfNotes = pdfNotesModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getMcqQuestions(String id) async {
    isLoading = true;
    update();
    Response response = await courseRepo.getMcqQuestions(id: id);
    ResponseModel responseModel = await checkResponseModel(response);
    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );
    if (responseModel.status == 200) {
      getQuestions = mcqModelFromJson(jsonEncode(responseModel.data));
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getAllContent(String id) async {
    isLoading = true;
    update();

    Response response = await courseRepo.getAllContent(id: id);
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status != 200,
    // );

    if (responseModel.status == 200) {
      // Make sure responseModel.data is a List
      allContentList = allContentModelFromJson(jsonEncode(responseModel.data));
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getBanner() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getBanner();
    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status != 200,
    // );

    if (responseModel.status == 200) {
      getBannerList = responseModel.data;
    }

    isLoading = false;
    update();
    return responseModel;
  }

  // Filter Courses by Search Query
  void filterCourses(String query) {
    if (query.isEmpty) {
      filteredCourses = _allCourses;
    } else {
      filteredCourses = _allCourses
          .where((course) =>
              course.courseName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(); // Refresh UI
  }

  Future<ResponseModel> addCourse(
      {required String coursename, required List thumbnailImg}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.addCourse(coursename, thumbnailImg);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addTest(
      {required String testName, required List thumbnailImg}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.addTest(testName, thumbnailImg);

    log("AddTest Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addContent(
      {  required String courseId,
        required String course,
      required String title,
      required String description,
      required File contentImg,
      required File contentVideo,
      required File contentPdf}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.addContent(

        courseId,course, title, description, contentImg, contentVideo, contentPdf);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}
    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addPdf(
      {required String course,
      required File contentImg,
      required File contentPdf}) async {
    isLoading=true;
    update();
    Response response =
        await courseRepo.addPdfs(course, contentImg, contentPdf);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addBanner({required File contentImg}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.addBanners(contentImg);

    log("Add Banner Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteContent(int contentId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deletecontent}$contentId");

      ResponseModel responseModel = await checkResponseModel(response);
      //
      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> postQuestionsAndAnswers(
      {required int testSeriesId,
      required String question,
      required String optionA,
      required String optionB,
      required String optionC,
      required String optionD,
      required String answer}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.postQuestions(
        testSeriesId, question, optionA, optionB, optionC, optionD, answer);

    log("jjoj" + jsonEncode(response.statusCode)); // Logs response status code

    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postTransactions({
    required String courseName,
    required String studentName,
    required String paymentMethod,
    required String amount,
    required String transactionId,
  }) async {
    isLoading=true;
    update();
    Response response = await courseRepo.postTransaction(
        courseName, studentName, paymentMethod, amount, transactionId);

    log("jjoj" + jsonEncode(response.statusCode)); // Logs response status code

    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteQuestion(int questionId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deleteQuestion}$questionId");

      ResponseModel responseModel = await checkResponseModel(response);

      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> deletePdfs(int pdfId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deletepdf}$pdfId");

      ResponseModel responseModel = await checkResponseModel(response);
      //
      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> deleteCourse(int courseId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deletecourse}$courseId");

      ResponseModel responseModel = await checkResponseModel(response);

      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> deleteTest(int testId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deleteTestSeries}$testId");

      ResponseModel responseModel = await checkResponseModel(response);

      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> reportProblem({
    required String type,
    required String description,
    required File image,
  }) async {
    isLoading = true;
    update();

    Response response = await courseRepo.postProblem(type, description, image);

    log("problem Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {}

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addPaidCourse(
      {required String teacherName,
      required String courseName,
      required String actualPrice,
      required String discountPrice,
      required List thumbnailImg}) async {
    isLoading=true;
    update();
    Response response = await courseRepo.addPaidCourse(
        teacherName, courseName, actualPrice, discountPrice, thumbnailImg);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);

    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {

    }
    isLoading=false;
    update();
    return responseModel;
  }



  Future<ResponseModel> deletePaidCourse(int courseId) async {
    isLoading=true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deletePaidCourse}$courseId");

      ResponseModel responseModel = await checkResponseModel(response);
      //
      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading=false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }


  Future<ResponseModel> addPaidCourseContent(
      {required String courseId,
      required String course,
      required String title,
      required String description,
      required File contentImg,
      required File contentVideo,
      required File contentPdf}) async {
    isLoading=true;
    update();

    Response response = await courseRepo.addPaidCourseContent(courseId, course,
        title, description, contentImg, contentVideo, contentPdf);

    log("AddCourse Response: ${jsonEncode(response.body)}");

    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(responseModel.message,
    //     isError: responseModel.status == 200 ? false : true);

    if (responseModel.status == 200) {
    }


    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getPaidCourseContent(String courseId) async {
    isLoading = true;
    update();
    try {
      Response response = await courseRepo.apiClient
          .getData('${AppConstants.getPaidCoursesContents}?course_id=$courseId');


      ResponseModel responseModel = await checkResponseModel(response);
      update();

      if (responseModel.status == 200) {
        paidCourseContents =
            paidCoursesContentsModelFromJson(jsonEncode(responseModel.data));
        update();
      }

      // showCustomSnackBar(
      //   responseModel.message,
      //   isError: responseModel.status != 200,
      // );
      isLoading = false;
      update();
      return responseModel;
    } catch (e) {
      // showCustomSnackBar("Something went wrong", isError: true);
      rethrow;
    }
  }

  Future<ResponseModel> deletePaidCourseContent(int contentId) async {
    try {
      Response response = await courseRepo.apiClient
          .deleteData("${AppConstants.deletePaidCourseContent}$contentId");

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


  Future<ResponseModel> getMyPaidCourses() async {
    isLoading = true;
    update();

    Response response = await courseRepo.getMyPaidCourse();
    ResponseModel responseModel = await checkResponseModel(response);
    //
    // showCustomSnackBar(
    //   responseModel.message,
    //   isError: responseModel.status == 200 ? false : true,
    // );

    if (responseModel.status == 200) {
      myPaidCourses = paidCoursesModelFromJson(jsonEncode(responseModel.data));

    }

    isLoading = false;
    update();
    return responseModel;
  }

}
