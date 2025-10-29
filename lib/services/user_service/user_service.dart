import 'dart:convert';
import 'dart:developer';
import 'package:heavek/constants/endpoints.dart';
import 'package:heavek/models/base_model.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/services/api_service/api_service.dart';
import 'package:heavek/services/api_service/auth_refresh_service.dart';
import 'package:heavek/utils/global_instances.dart';

class UserService implements AuthRefreshService {
  // Private constructor
  UserService._privateConstructor();

  // Singleton instance variable
  static UserService? _instance;

  // Getter to access the singleton instance
  static UserService get instance {
    _instance ??= UserService._privateConstructor();
    return _instance!;
  }

  // Get reference to the base API service
  APIService get _apiService => apiService;

  // User authentication endpoints
  static const String _loginEndpoint = '$accountsLink/login';
  static const String _registerEndpoint = '$accountsLink/register';
  static const String _verifyOtpEndpoint = '$accountsLink/verify-otp';
  static const String _forgotPasswordEndpoint = '$accountsLink/forgot-password';
  static const String _getUserProfileEndpoint = '$accountsLink/profile';
  static const String _updateUserProfileEndpoint = '$accountsLink/profile';

  /// Login user with email and password
  Future<UserModel?> loginUser({required String email, required String password}) async {
    try {
      final body = {'email': email, 'password': password};

      final response = await _apiService.post(
        _loginEndpoint,
        body,
        true, // isBasic
        successCode: 200,
        showResult: true,
      );

      if (response != null) {
        return UserModel.fromMap(response);
      }
      return null;
    } catch (e) {
      log('Error in loginUser: $e');
      return null;
    }
  }

  /// Register new user
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };

      final response = await _apiService.post(
        _registerEndpoint,
        body,
        true, // isBasic
        successCode: 201,
        showResult: true,
      );

      if (response != null) {
        return UserModel.fromMap(response);
      }
      return null;
    } catch (e) {
      log('Error in registerUser: $e');
      return null;
    }
  }

  /// Verify OTP
  Future<BaseModel?> verifyOtp({required String email, required String otp}) async {
    try {
      final body = {'email': email, 'otp': otp};

      final response = await _apiService.post(
        _verifyOtpEndpoint,
        body,
        true, // isBasic
        successCode: 200,
        showResult: true,
      );

      if (response != null) {
        return BaseModel.fromMap(response);
      }
      return null;
    } catch (e) {
      log('Error in verifyOtp: $e');
      return null;
    }
  }

  /// Forgot password
  Future<BaseModel?> forgotPassword({required String email}) async {
    try {
      final body = {'email': email};

      final response = await _apiService.post(
        _forgotPasswordEndpoint,
        body,
        true, // isBasic
        successCode: 200,
        showResult: true,
      );

      if (response != null) {
        return BaseModel.fromMap(response);
      }
      return null;
    } catch (e) {
      log('Error in forgotPassword: $e');
      return null;
    }
  }

  /// Update user profile (requires authentication)
  Future<UserModel?> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dateOfBirth,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;

      final response = await _apiService.patch(
        _updateUserProfileEndpoint,
        false, // not basic, requires auth token
        body,
        successCode: 200,
        showResult: true,
      );

      if (response?.statusCode == 200 && response?.body != null) {
        final Map<String, dynamic> responseData = jsonDecode(response!.body);
        return UserModel.fromMap(responseData);
      }
      return null;
    } catch (e) {
      log('Error in updateUserProfile: $e');
      return null;
    }
  }

  /// Get authentication token using username and secret
  Future<bool> getAuthToken({required String username, required String secret}) async {
    try {
      final body = {"username": username, "secret": secret};

      final response = await _apiService.postExpectString(
        authTokenUrl,
        body,
        true, // isBasic
        showResult: true,
      );

      if (response != null) {
        // Centralized token writing logic
        await localStorageService.writeSecureString(key: userTokenKey, value: response);
        log('Auth token written to secure storage');
        return true;
      }
      return false;
    } catch (e) {
      log('Error in getAuthToken: $e');
      return false;
    }
  }

  /// Check account status by email
  Future<(int?, int?)> checkAccountStatus({required String email}) async {
    try {
      final (response, statusCode) = await _apiService.get(
        '$accountsLink/$email/status',
        false, // requires auth token
        successCode: 200,
        showResult: true,
      );

      if (response != null && statusCode != null && (statusCode == 200 || statusCode == 201)) {
        int data = response['data'];
        return (data, statusCode);
      }
      return (null, statusCode);
    } catch (e) {
      log('Error in checkAccountStatus: $e');
      return (null, null);
    }
  }

  /// Sign up user with email and password
  Future<(bool, int?)> signupWithEmailPassword({required String email, required String password}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/sign-up-password',
        {"emailAddress": email, "password": password},
        false, // requires auth token
        showResult: true,
      );

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return (true, response.statusCode);
      }
      return (false, response?.statusCode);
    } catch (e) {
      log('Error in signupWithEmailPassword: $e');
      return (false, null);
    }
  }

  /// Login user and get auth token
  Future<(String?, int?)> loginAndGetAuthToken({required String email, required String password}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/login',
        {"emailAddress": email, "password": password},
        false, // requires auth token
        showResult: true,
      );

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        Map<String, dynamic> authData = jsonDecode(response.body);
        String authToken = authData['data'];

        // Centralized token writing logic
        await localStorageService.writeSecureString(key: userAuthTokenKey, value: authToken);
        await localStorageService.writeSecureString(key: userEmailKey, value: email);
        await localStorageService.writeSecureString(key: userPasswordKey, value: password);
        log('Auth token written to secure storage');

        return (authToken, response.statusCode);
      }
      return (null, response?.statusCode);
    } catch (e) {
      log('Error in loginAndGetAuthToken: $e');
      return (null, null);
    }
  }

  /// Get user profile with authentication
  Future<UserModel?> getUserProfile({required String email}) async {
    try {
      final (response, statusCode) = await _apiService.get(
        '$accountsLink/$email/user-profile',
        false, // requires auth token
        isAuth: true,
        successCode: 200,
        showResult: true,
      );

      if (response != null && statusCode != null) {
        // Create UserModel with the actual statusCode and extract user data
        final userData = response['data'] ?? {};
        final messages = response['messages'] ?? <String>[];

        // Create UserModel from the data and include statusCode from response
        final userModel = UserModel.fromMap({...userData, 'statusCode': statusCode, 'messages': messages});

        return userModel;
      }
      return null;
    } catch (e) {
      log('Error in getUserProfileWithAuth: $e');
      return null;
    }
  }

  /// Verify OTP for email verification
  Future<(int?, BaseModel?)> verifyEmailOtp({required String email, required String otp}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/verify',
        {"emailAddress": email, "validationCode": otp},
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return (data as int?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in verifyEmailOtp: $e');
      return (null, null);
    }
  }

  /// Complete user profile (requires authentication)
  Future<UserModel?> completeUserProfile({required String email, required UserModel user}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/profile',
        user.toMap(),
        false, // requires auth token
        isAuth: true,
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final messages = responseData['messages'] ?? <String>[];

        // Create UserModel with statusCode and messages from response
        final userModel = UserModel.fromMap({...responseData, 'statusCode': response.statusCode, 'messages': messages});

        return userModel;
      }
      return null;
    } catch (e) {
      log('Error in completeUserProfile: $e');
      return null;
    }
  }

  /// Resend OTP verification code
  Future<BaseModel?> resendOtp({required String email}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/resend-verification-code',
        {"emailAddress": email},
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return baseModel;
      }
      return null;
    } catch (e) {
      log('Error in resendOtp: $e');
      return null;
    }
  }

  /// Send forgot password email
  Future<(int?, BaseModel?)> sendForgotPasswordEmail({required String email}) async {
    try {
      final response = await _apiService.postWithResponseWithoutBody(
        '$accountsLink/$email/forgot-password',
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return (data as int?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in sendForgotPasswordEmail: $e');
      return (null, null);
    }
  }

  /// Resend forgot password email verification code
  Future<(bool?, BaseModel?)> resendForgotPasswordEmail({required String email}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/forgot-password/resend-verification-code',
        {"emailAddress": email},
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return (data as bool?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in resendForgotPasswordEmail: $e');
      return (null, null);
    }
  }

  /// Verify forgot password OTP
  /// Returns (int?, BaseModel?) tuple where int represents verification result and BaseModel contains response metadata
  Future<(int?, BaseModel?)> verifyForgotPasswordOtp({required String email, required String otp}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/forgot-password/verify',
        {"emailAddress": email, "validationCode": otp},
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return (data as int?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in verifyForgotPasswordOtp: $e');
      return (null, null);
    }
  }

  /// Reset forgot password
  /// Returns (bool?, BaseModel?) tuple where bool indicates success and BaseModel contains response metadata
  Future<(bool?, BaseModel?)> resetForgotPassword({required String email, required String password}) async {
    try {
      final response = await _apiService.postWithResponse(
        '$accountsLink/$email/reset-password',
        {"emailAddress": email, "password": password},
        false, // requires auth token
        showResult: true,
      );

      if (response != null) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: response.statusCode, messages: List<String>.from(messages));

        return (data as bool?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in resetForgotPassword: $e');
      return (null, null);
    }
  }

  /// Check username availability
  /// Returns (bool?, BaseModel?) tuple where bool indicates username availability and BaseModel contains response metadata
  Future<(bool?, BaseModel?)> checkUsernameAvailability({required String username}) async {
    try {
      final response = await _apiService.get(
        '$accountsLink/$username/check-username',
        false, // not basic, requires auth token
        isAuth: true,
      );

      final responseData = response.$1;
      final statusCode = response.$2;

      if (responseData != null && statusCode != null) {
        final data = responseData['data'];
        final messages = responseData['messages'] ?? <String>[];

        // Create BaseModel with statusCode and messages
        final baseModel = BaseModel(statusCode: statusCode, messages: List<String>.from(messages));

        return (data as bool?, baseModel);
      }
      return (null, null);
    } catch (e) {
      log('Error in checkUsernameAvailability: $e');
      return (null, null);
    }
  }

  /// Delete user account (requires authentication)
  Future<BaseModel?> deleteUserAccount() async {
    try {
      final response = await _apiService.delete(
        _getUserProfileEndpoint,
        false, // not basic, requires auth token
        successCode: 200,
        showResult: true,
      );

      if (response != null) {
        return BaseModel.fromMap(response);
      }
      return null;
    } catch (e) {
      log('Error in deleteUserAccount: $e');
      return null;
    }
  }

  /// Refresh authentication token (implements AuthRefreshService)
  @override
  Future<void> refreshAuthToken() async {
    try {
      // Implement your token refresh logic here
      // This method will be called by APIService on 401/403 errors
      log('Refreshing authentication token...');

      await getAuthToken(username: globalUsername!, secret: globalUSecret!);
    } catch (e) {
      log('Error refreshing auth token: $e');
    }
  }

  /// Refresh auth user token (for 403 errors)
  @override
  Future<void> refreshAuthUserToken() async {
    try {
      log('Refreshing auth user token...');

      // Get the current user's email from global user model
      final userEmail = await localStorageService.readSecureString(key: userEmailKey);
      final userPassword = await localStorageService.readSecureString(key: userPasswordKey);

      // Get auth token using login credentials
      await loginAndGetAuthToken(email: userEmail!, password: userPassword!);
    } catch (e) {
      log('Error refreshing auth user token: $e');
    }
  }
}
