import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:heavek/utils/custom_snackbars.dart';
import 'package:heavek/utils/enums.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/utils/network_connectivity.dart';
import 'package:http/http.dart' as http;

Map<String, String> basicHeaderInfo() => {
  HttpHeaders.acceptHeader: "application/json",
  HttpHeaders.contentTypeHeader: "application/json",
};

Future<Map<String, String>> bearerHeaderInfo() async {
  String? token = await localStorageService.readString(key: userTokenKey);
  return token != null
      ? {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          // HttpHeaders.acceptLanguageHeader: "en"
        }
      : basicHeaderInfo();
}

Future<Map<String, String>> bearerAuthHeaderInfo() async {
  String? token = await localStorageService.readString(key: userTokenKey);
  String? authToken = await localStorageService.readString(
    key: userAuthTokenKey,
  );
  return token != null && authToken != null
      ? {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          "AuthorizedUser": "Auth $authToken",
        }
      : basicHeaderInfo();
}

class APIService {
  // Private constructor
  APIService._privateConstructor();

  // Singleton instance variable
  static APIService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to APIService.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static APIService get instance {
    _instance ??= APIService._privateConstructor();
    return _instance!;
  }

  //method to check if the device is connected to internet
  Future<bool> isConnectedToInternet() async {
    NetworkStatus networkStatus = await NetworkConnectivity.instance
        .getNetworkStatus();

    if (networkStatus == NetworkStatus.online) {
      return true;
    } else {
      return false;
    }
  }

  // Get method
  Future<(Map<String, dynamic>?, int?)> get(
    String url,
    bool isBasic, {
    bool isAuth = false,
    int successCode = 200,
    int duration = 120,
    bool showResult = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    String finalUrl = '';
    //Setting the final Url in case of parameters are provided
    if (queryParameters != null && queryParameters.isNotEmpty) {
      // Encode the query parameters
      String queryString = Uri(queryParameters: queryParameters).query;
      finalUrl = '$url?$queryString';
    } else {
      finalUrl = url;
    }
    log("QUERY PARAMS  $finalUrl ");

    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return (null, null);
    }

    try {
      final response = await http
          .get(
            Uri.parse(finalUrl),
            headers: isAuth
                ? await bearerAuthHeaderInfo()
                : isBasic
                ? basicHeaderInfo()
                : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("GET API RESPONSE ($url): ${response.body}");
        log("GET API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return (
          jsonDecode(response.body) as Map<String, dynamic>,
          response.statusCode,
        );
      } else {
        log(
          'Get API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return (
          jsonDecode(response.body) as Map<String, dynamic>,
          response.statusCode,
        );
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return (null, null);
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return (null, null);
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return (null, null);
    } catch (e) {
      log("This exception occured while hitting Get API call ($url): $e");

      return (null, null);
    }
  }

  // Get method
  Future<(List?, int?)> getListResponse(
    String url,
    bool isBasic, {
    int successCode = 200,
    int duration = 120,
    bool showResult = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    String finalUrl = '';
    //Setting the final Url in case of parameters are provided

    if (queryParameters != null && queryParameters.isNotEmpty) {
      // Encode the query parameters
      String queryString = Uri(queryParameters: queryParameters).query;
      finalUrl = '$url?$queryString';
    } else {
      finalUrl = url;
    }
    log("QUERY PARAMS  $finalUrl ");

    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      return (null, null);
    }

    try {
      final response = await http
          .get(
            Uri.parse(finalUrl),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("GET API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return (jsonDecode(response.body) as List, response.statusCode);
      } else {
        log(
          'Get API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return (jsonDecode(response.body) as List, response.statusCode);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      return (null, null);
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      return (null, null);
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      return (null, null);
    } catch (e) {
      log("This exception occured while hitting Get API call ($url): $e");

      return (null, null);
    }
  }

  // Post Method
  Future<Map<String, dynamic>?> post(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 201,
    int duration = 60,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      log("BODY IS ${body}");
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log(
          'POST API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post Method Returns String
  Future<String?> postExpectString(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 201,
    int duration = 60,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      log("BODY IS ${body}");
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return response.body;
      } else {
        log(
          'POST API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post Method
  Future<http.Response?> postWithResponse(
    String url,
    Map<String, dynamic>? body,
    bool isBasic, {
    bool isAuth = false,
    int duration = 120,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      return null;
    }
    try {
      // DialogService.instance.showProgressDialog(context: context);
      http.Response response;
      if (body == null) {
        response = await http
            .post(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isAuth
                  ? await bearerAuthHeaderInfo()
                  : isBasic
                  ? basicHeaderInfo()
                  : headers ?? await bearerHeaderInfo(),
            )
            .timeout(Duration(seconds: duration));
      } else {
        response = await http
            .post(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isAuth
                  ? await bearerAuthHeaderInfo()
                  : isBasic
                  ? basicHeaderInfo()
                  : headers ?? await bearerHeaderInfo(),
            )
            .timeout(Duration(seconds: duration));
      }
      log(" RESPONSE ::: ${response.body}");
      // ;
      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }
      return response;
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');
      // ;

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());
      // ;

      return null;
    } catch (e) {
      // ;

      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post with Response without Body
  Future<http.Response?> postWithResponseWithoutBody(
    String url,
    bool isBasic, {
    bool isAuth = false,
    int duration = 120,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      return null;
    }
    try {
      // DialogService.instance.showProgressDialog(context: context);
      http.Response response;
      response = await http
          .post(
            Uri.parse(url),
            headers: isAuth
                ? await bearerAuthHeaderInfo()
                : isBasic
                ? basicHeaderInfo()
                : headers ?? await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      log(" RESPONSE ::: ${response.body}");
      // ;
      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }
      return response;

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   log('POST API call failed with status code ($url): ${response.statusCode}');
      //   CustomSnackBars.instance
      //       .showFailureSnackBar(title: "Failure", message: response.body);
      //   return null;
      // }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');
      // ;

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');
      // ;

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());
      // ;

      return null;
    } catch (e) {
      // ;

      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post Method with string response
  Future<String?> postWithStringResponse(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      return response.body;
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post Method with string response
  Future<int?> postWithIntResponse(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      return response.statusCode;
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Patch Method
  Future<http.Response?> patch(
    String url,
    bool isBasic,
    Map<String, dynamic> body, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      return null;
    }
    try {
      log("Patch API Call");
      final response = await http
          .patch(
            body: jsonEncode(body),
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
      log("patch RESPONSE ($url): ${response}");

      if (showResult) {
        log("patch API RESPONSE ($url): ${response.body}");
        log("patch API STATUS CODE ($url): ${response.statusCode}");
      }

      return response;
    } catch (e) {
      log("Exception e = $e");
      return null;
    }
  }

  Future<http.Response?> patchWithResponse(
    String url,
    bool isBasic,
    Map<String, dynamic> body, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      final response = await http
          .patch(
            body: jsonEncode(body),
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("patch API RESPONSE ($url): ${response.body}");
        log("patch API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return response;
      } else {
        log(
          'patch API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return response;
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occurred while hitting patch API call ($url): $e");

      return null;
    }
  }

  // Put Method
  Future<http.Response?> put(
    String url,
    Map<String, dynamic>? body,
    bool isBasic, {
    int duration = 120,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      // DialogService.instance.showProgressDialog(context: context);
      http.Response response;
      if (body == null) {
        response = await http
            .put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isBasic ? basicHeaderInfo() : headers,
            )
            .timeout(Duration(seconds: duration));
      } else {
        response = await http
            .put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
            )
            .timeout(Duration(seconds: duration));
      }
      log(" RESPONSE ::: ${response.body}");
      // ;
      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }
      return response;

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   log('POST API call failed with status code ($url): ${response.statusCode}');
      //   CustomSnackBars.instance
      //       .showFailureSnackBar(title: "Failure", message: response.body);
      //   return null;
      // }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');
      // ;

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');
      // ;

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());
      // ;

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      // ;

      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Delete method
  Future<Map<String, dynamic>?> delete(
    String url,
    bool isBasic, {
    int successCode = 200,
    int duration = 15,
    bool showResult = false,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    try {
      var headers = isBasic ? basicHeaderInfo() : await bearerHeaderInfo();

      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("DELETE API RESPONSE ($url): ${response.body}");
        log("DELETE API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log(
          'POST API call failed with status code ($url): ${response.statusCode}',
        );

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Failure",
        message: "Check your Internet Connection and try again!",
      );

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Timeout",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Client Exception",
        message: "Something Went Wrong! Try Again",
      );

      return null;
    } catch (e) {
      log("This exception occured while hitting Get API call ($url): $e");

      return null;
    }
  }
}
