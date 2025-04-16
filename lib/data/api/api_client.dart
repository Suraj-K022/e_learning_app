import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CustomWidgets/custom_snackbar.dart';
import '../../controller/auth_controller.dart';
import '../../utils/app_constants.dart';
import '../model/base/error_response.dart';

class ApiClient extends GetxService {
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  late Map<String, String> _mainHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ',
    'Accept': 'application/json',
  };

  String? token;

  ApiClient({required this.sharedPreferences}) {  updateHeader(sharedPreferences.getString(AppConstants.token) ?? '');}

  Future<void> updateHeader(String? token) async {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      log('====> API Call: Header: $_mainHeaders');
      log('====> API Call: Url: ${AppConstants.baseUrl}$uri');
      http.Response response = await http
          .get(
        Uri.parse(AppConstants.baseUrl + uri),
        headers: headers ?? _mainHeaders,
      )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      log('====> API Call: Header: $_mainHeaders');
      log('====> API Call: Url: ${AppConstants.baseUrl}$uri');
      log('====> API Body: ${jsonEncode(body)}');
      http.Response response = await http
          .post(
        Uri.parse(AppConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }



  Future<Response> postMultipartData(
      String uri, {
        Map<String, String>? body,
        Map<String, String>? headers,
        List<MultipartBody>? multipartBody,
      }) async {
    try {
      log('====> API Call: Header: $_mainHeaders');
      log('====> API Call: Url: ${AppConstants.baseUrl}$uri');
      log('====> API Body: $body');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.baseUrl + uri),
      );

      request.headers.addAll(headers ?? _mainHeaders);

      if (body != null) {
        request.fields.addAll(body);
      }

      if (multipartBody != null) {
        for (var element in multipartBody) {
          log("Uploading file: ${element.file}");
          request.files.add(
            await http.MultipartFile.fromPath(
              element.key,
              element.file,
            ),
          );
        }
      }

      // Debug log for all files being uploaded
      for (var file in request.files) {
        log("File attached => Name: ${file.filename}, Field: ${file.field}");
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Server Response: ${response.body}");

      return handleResponse(response, uri);
    } catch (e) {
      log("Error during multipart upload: $e");
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


//   Future<Response> postMultipartData(String uri,
//       {Map<String, String>? body,
//         Map<String, String>? headers,
//         List<MultipartBody>? multipartBody}) async {
//     try {
//       log('====> API Call: Header: $_mainHeaders');
//       log('====> API Call: Url: ${AppConstants.baseUrl}$uri');
//       log('====> API Body: $body');
//
//       http.MultipartRequest request = http.MultipartRequest(
//         'POST',
//         Uri.parse(AppConstants.baseUrl + uri),
//       );
//
//       request.headers.addAll(headers ?? _mainHeaders);
//
//       if (body != null) {
//         request.fields.addAll(body);
//       }
//
//       if (multipartBody != null) {
//         multipartBody.forEach(
//
//           (element)async {
//             print("sdfsdfd ${element.file}");
//             request.files.add(
//               await http.MultipartFile.fromPath(
//                 element.key,
//                 element.file.toString(),
//                 // contentType: MediaType("image", "jpeg"),
//               ),
//             );
//
//           },
//         );
//         // for (var item in multipartBody) {
//         //   print("sdfsdfd ${item.file}");
//
//         // }
//       }
//       print("sdfsdfd ${request.files}");
//       // // Log file details
//       // for (var file in request.files) {
//       //   log("File Info => Name: ${file.filename}, Field: ${file.field}, Length: ${file.length}");
//       // }
//
//
//       http.Response response =
//       await http.Response.fromStream(await request.send());
// log("asdsd ${response.body}");
//       return handleResponse(response, uri);
//     } catch (e) {
//       return Response(statusCode: 1, statusText: e.toString());
//     }
//   }


  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      log('====> API Call: Header: $_mainHeaders');
      log('====> API Call: Url: ${AppConstants.baseUrl}$uri');
      log('====> API Body: $body');
      http.Response response = await http
          .put(
        Uri.parse(AppConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      log('====> API Call: $uri\nHeader: $_mainHeaders');
      http.Response response = await http
          .delete(
        Uri.parse(AppConstants.baseUrl + uri),
        headers: headers ?? _mainHeaders,
      )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Response handleResponse(http.Response res, String uri) {
    dynamic body;

    try {
      body = jsonDecode(res.body);
      debugPrint(body.toString());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    Response response = Response(
      body: body ?? res.body,
      bodyString: res.body.toString(),
      request: Request(
        headers: res.request!.headers,
        method: res.request!.method,
        url: res.request!.url,
      ),
      headers: res.headers,
      statusCode: res.statusCode,
      statusText: res.reasonPhrase,
    );

    if (response.statusCode != 200 &&
        response.body != null &&
        response.body is! String) {
      if (response.statusCode == 401) {
        showCustomSnackBar('401', isError: true);
        Get.find<AuthController>().isLoggedIn();
      } else if (response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response.body);
        response = Response(
          statusCode: response.statusCode,
          body: response.body,
          statusText: errorResponse.errors![0].message,
        );
      } else if (response.body.toString().startsWith('{status')) {
        response = Response(
          statusCode: response.statusCode,
          body: response.body,
          statusText: response.body['message'],
        );
      }
    } else if (response.statusCode != 200 && response.body == null) {
      response = const Response(
        statusCode: 0,
        statusText: noInternetMessage,
      );
    }

    if (!(response.body.toString().startsWith('{'))) {
      log('====> API Response: [${response.statusCode}] $uri\n${json.encode(response.body.toString())}');
      response = Response(
        statusCode: response.statusCode,
        body: {"status": false, "message": "Internal Server Error"},
        statusText: "Internal Server Error",
      );
    }

    return response;
  }
}

class MultipartBody {
  final String key;
  final String file;

  MultipartBody(this.key, this.file);
}
