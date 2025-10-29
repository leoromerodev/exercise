import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'auth_refresh_service.dart';
import 'package:heavek/services/user_service/user_service.dart';
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
  String? token = await localStorageService.readSecureString(key: userTokenKey);
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
  String? token = await localStorageService.readSecureString(key: userTokenKey);
  String? authToken = await localStorageService.readSecureString(
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
  APIService._privateConstructor({AuthRefreshService? authRefreshService})
      : _authRefreshService = authRefreshService;

  // Singleton instance variable
  static APIService? _instance;
  
  // Auth refresh service instance
  AuthRefreshService? _authRefreshService;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to APIService.instance will return the same instance that was created before.

  // Factory method to create instance with auth refresh service
  static APIService createInstance({AuthRefreshService? authRefreshService}) {
    _instance ??= APIService._privateConstructor(authRefreshService: authRefreshService);
    return _instance!;
  }

  // Getter to access the singleton instance (for backward compatibility)
  static APIService get instance {
    _instance ??= APIService._privateConstructor();
    return _instance!;
  }

  // Method to set auth refresh service after creation
  void setAuthRefreshService(AuthRefreshService authRefreshService) {
    log('Setting auth refresh service: ${authRefreshService.runtimeType}');
    _authRefreshService = authRefreshService;
    log('Auth refresh service set successfully. Is null? ${_authRefreshService == null}');
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

  // Common method to execute HTTP calls with error handling
  Future<http.Response?> executeHttpCall(Future<http.Response> Function() httpCall, {bool retry = true}) async {
    // Check internet connectivity first
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      CustomSnackBars.instance.showFailureSnackBar(
        title: "No Internet Connection",
        message: "Please check your internet connection and try again!",
      );
      return null;
    }
    // Try to get auth refresh service if not set
        AuthRefreshService? authService = _authRefreshService;
        if (authService == null) {
          log('Auth refresh service is null, trying to get UserService instance...');
          try {
            authService = UserService.instance;
            log('Got UserService instance: ${authService.runtimeType}');
          } catch (e) {
            log('Failed to get UserService instance: $e');
          }
        }

    try {
      final response = await httpCall();
      
      // Handle authentication errors (401, 403) after successful HTTP call
      if (response.statusCode == 401) {
        log('401 response detected. Auth refresh service is null? ${_authRefreshService == null}');
        await localStorageService.deleteSecureKey(key: userTokenKey);
        
        if (authService != null) {
          log('Calling refreshAuthToken...');
          await authService.refreshAuthToken();
          if(retry){
            return await executeHttpCall(httpCall, retry: true);
          }
        } else {
          log('Auth refresh service is still null, cannot refresh token');
        }
      }
      
      if (response.statusCode == 403) {
        log('403 response detected. Auth refresh service is null? ${_authRefreshService == null}');
        await localStorageService.deleteSecureKey(key: userAuthTokenKey);
        
        if (authService != null) {
          log('Calling refreshAuthUserToken...');
          await authService.refreshAuthUserToken();
          if(retry){
            return await executeHttpCall(httpCall, retry: false);
          }
        } else {
          log('Auth refresh service is still null, cannot refresh auth user token');
        }
      }
      
      return response;
    } catch (e) {
      log("HTTP call failed: $e");
      
      // Handle other exceptions with snackbar
      CustomSnackBars.instance.showFailureSnackBar(
        title: "Request Failed",
        message: "Something went wrong. Please try again.",
      );

      return null;
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

    final response = await executeHttpCall(() async {
      return await http
          .get(
            Uri.parse(finalUrl),
            headers: isAuth
                ? await bearerAuthHeaderInfo()
                : isBasic
                ? basicHeaderInfo()
                : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return (null, null);
    }

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

      return (
        jsonDecode(response.body) as Map<String, dynamic>,
        response.statusCode,
      );
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

    final response = await executeHttpCall(() async {
      return await http
          .get(
            Uri.parse(finalUrl),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return (null, null);
    }

    if (showResult) {
      log("GET API STATUS CODE ($url): ${response.statusCode}");
    }

    if (response.statusCode == successCode) {
      return (jsonDecode(response.body) as List, response.statusCode);
    } else {
      log(
        'Get API call failed with status code ($url): ${response.statusCode}',
      );

      return (jsonDecode(response.body) as List, response.statusCode);
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
    log("BODY IS $body");
    
    final response = await executeHttpCall(() async {
      return await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

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
      return jsonDecode(response.body);
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
    log("BODY IS $body");
    
    final response = await executeHttpCall(() async {
      return await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

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
      return jsonDecode(response.body);
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
    final response = await executeHttpCall(() async {
      if (body == null) {
        return await http
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
        return await http
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
    });

    if (response == null) {
      return null;
    }

    log(" RESPONSE ::: ${response.body}");
    if (showResult) {
      log("POST API RESPONSE ($url): ${response.body}");
      log("POST API STATUS CODE ($url): ${response.statusCode}");
    }
    return response;
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
    final response = await executeHttpCall(() async {
      return await http
          .post(
            Uri.parse(url),
            headers: isAuth
                ? await bearerAuthHeaderInfo()
                : isBasic
                ? basicHeaderInfo()
                : headers ?? await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

    log(" RESPONSE ::: ${response.body}");
    if (showResult) {
      log("POST API RESPONSE ($url): ${response.body}");
      log("POST API STATUS CODE ($url): ${response.statusCode}");
    }
    return response;
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
    final response = await executeHttpCall(() async {
      return await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

    if (showResult) {
      log("POST API RESPONSE ($url): ${response.body}");
      log("POST API STATUS CODE ($url): ${response.statusCode}");
    }

    return response.body;
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
    final response = await executeHttpCall(() async {
      return await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

    if (showResult) {
      log("POST API RESPONSE ($url): ${response.body}");
      log("POST API STATUS CODE ($url): ${response.statusCode}");
    }

    return response.statusCode;
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
    log("Patch API Call");
    
    final response = await executeHttpCall(() async {
      return await http
          .patch(
            body: jsonEncode(body),
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

    log("patch RESPONSE ($url): $response");
    if (showResult) {
      log("patch API RESPONSE ($url): ${response.body}");
      log("patch API STATUS CODE ($url): ${response.statusCode}");
    }

    return response;
  }

  Future<http.Response?> patchWithResponse(
    String url,
    bool isBasic,
    Map<String, dynamic> body, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
  }) async {
    final response = await executeHttpCall(() async {
      return await http
          .patch(
            body: jsonEncode(body),
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

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
      return response;
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
    final response = await executeHttpCall(() async {
      if (body == null) {
        return await http
            .put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isBasic ? basicHeaderInfo() : headers,
            )
            .timeout(Duration(seconds: duration));
      } else {
        return await http
            .put(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
            )
            .timeout(Duration(seconds: duration));
      }
    });

    if (response == null) {
      return null;
    }

    log(" RESPONSE ::: ${response.body}");
    if (showResult) {
      log("POST API RESPONSE ($url): ${response.body}");
      log("POST API STATUS CODE ($url): ${response.statusCode}");
    }
    return response;
  }

  // Delete method
  Future<Map<String, dynamic>?> delete(
    String url,
    bool isBasic, {
    int successCode = 200,
    int duration = 15,
    bool showResult = false,
  }) async {
    final response = await executeHttpCall(() async {
      var headers = isBasic ? basicHeaderInfo() : await bearerHeaderInfo();
      return await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: duration));
    });

    if (response == null) {
      return null;
    }

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
      return jsonDecode(response.body);
    }
  }
}
