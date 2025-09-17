import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/endpoints.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/utils/functions.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/auth/auth_screen.dart';
import 'package:heavek/views/screens/auth/change_password_screen.dart';
import 'package:heavek/views/screens/auth/complete_profile_screen.dart';
import 'package:heavek/views/screens/auth/forgot_password_verification_screen.dart';
import 'package:heavek/views/screens/auth/set_password_screen.dart';
import 'package:heavek/views/screens/auth/verification_screen.dart';
import 'package:heavek/views/screens/nav_bar/bottom_nav_bar.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final dobController = TextEditingController();
  final otpController = TextEditingController();
  DateTime? selectedDate;

  RxBool isLoading = false.obs;

  Future<void> getAuthToken() async {
    Map<String, dynamic> body = {
      "username": globalUsername,
      "secret": globalUSecret,
    };
    final response = await apiService.postExpectString(
      authTokenUrl,
      body,
      true,
    );
    if (response != null) {
      await localStorageService.writeString(key: userTokenKey, value: response);
    }
    log(response.toString());
  }

  Future<void> checkAccountStatus({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.get('$accountsLink/$email/status', false);
    if (response.$2 != null &&
        response.$1 != null &&
        (response.$2 == 200 || response.$2 == 201)) {
      int data = response.$1?['data'];
      if (data == 1) {
        //AccountExist
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Account already exist, Try Login!',
        );
      } else if (data == 2) {
        //EmailVerified
        dialogService.hideLoading(context);
        Get.offAll(() => SetPasswordScreen());
      } else if (data == 3) {
        //EmailUnverified
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Email Sent',
          message: 'Verification Email is sent to $email, check you inbox.',
        );
        Get.offAll(() => VerificationScreen());
      } else {
        dialogService.hideLoading(context);
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> signupEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/sign-up-password',
      {"emailAddress": email, "password": toBase64(password)},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      final loginResponse = await apiService.postWithResponse(
        '$accountsLink/$email/login',
        {"emailAddress": email, "password": toBase64(password)},
        false,
      );

      if (loginResponse != null &&
          (loginResponse.statusCode == 200 ||
              loginResponse.statusCode == 201)) {
        Map<String, dynamic> authData = jsonDecode(loginResponse.body);
        String authToken = authData['data'];
        await localStorageService.writeString(
          key: userAuthTokenKey,
          value: authToken,
        );

        final profileResponse = await apiService.get(
          '$accountsLink/$email/user-profile',
          false,
          isAuth: true,
        );
        if (profileResponse.$1 != null &&
            profileResponse.$2 != null &&
            (profileResponse.$2 == 200 || profileResponse.$2 == 201)) {
          userModelGlobal.value = UserModel.fromMap(
            profileResponse.$1?['data'],
          );
          if (userModelGlobal.value?.firstName == null ||
              userModelGlobal.value?.screenName == null) {
            Get.offAll(() => CompleteProfileScreen());
          } else {
            dialogService.hideLoading(context);
            customSnackBars.showSuccessSnackBar(
              title: 'Success',
              message: 'Signup Successfull',
            );
            resetValues();
            Get.offAll(() => BottomNavBar());
          }
        } else {
          dialogService.hideLoading(context);
        }
      } else {
        dialogService.hideLoading(context);
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> verifyOTP({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/verify',
      {"emailAddress": email, "validationCode": otp},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> decodedRes = jsonDecode(response.body);
      int data = decodedRes['data'];
      if (data == 1) {
        // Verification Success
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Code Verified Successfully.',
        );
        Get.offAll(() => SetPasswordScreen());
      } else if (data == 2) {
        // Invalid code or email
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Invalid Code or Email, Try again.',
        );
      } else if (data == 3) {
        // code expired
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Code Expired',
          message: 'Try sending code again.',
        );
      } else {
        dialogService.hideLoading(context);
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> loginEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final loginResponse = await apiService.postWithResponse(
      '$accountsLink/$email/login',
      {"emailAddress": email, "password": toBase64(password)},
      false,
      showResult: true,
    );
    log('login res code : ${loginResponse?.statusCode}');

    if (loginResponse != null &&
        (loginResponse.statusCode == 200 || loginResponse.statusCode == 201)) {
      Map<String, dynamic> authData = jsonDecode(loginResponse.body);
      String authToken = authData['data'];
      await localStorageService.writeString(
        key: userAuthTokenKey,
        value: authToken,
      );

      final profileResponse = await apiService.get(
        '$accountsLink/$email/user-profile',
        false,
        isAuth: true,
      );
      if (profileResponse.$1 != null &&
          profileResponse.$2 != null &&
          (profileResponse.$2 == 200 || profileResponse.$2 == 201)) {
        userModelGlobal.value = UserModel.fromMap(profileResponse.$1?['data']);
        if (userModelGlobal.value?.firstName == null ||
            userModelGlobal.value?.screenName == null) {
          Get.offAll(() => CompleteProfileScreen());
        } else {
          dialogService.hideLoading(context);
          customSnackBars.showSuccessSnackBar(
            title: 'Success',
            message: 'Login Successfull',
          );
          resetValues();
          Get.offAll(() => BottomNavBar());
        }
      } else {
        dialogService.hideLoading(context);
      }
    } else {
      dialogService.hideLoading(context);
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: 'Invalid credentials',
      );
    }
  }

  Future<void> completeUserProfile({
    required UserModel user,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/${user.email}/profile',
      user.toMap(),
      false,
      isAuth: true,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> profileResponse = jsonDecode(response.body);
      userModelGlobal.value = UserModel.fromMap(profileResponse);
      dialogService.hideLoading(context);
      customSnackBars.showSuccessSnackBar(
        title: 'Success',
        message: 'Profile updated successfully.',
      );
      resetValues();
      Get.offAll(() => BottomNavBar());
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> resendOtp({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/resend-verification-code',
      {"emailAddress": email},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      dialogService.hideLoading(context);
      customSnackBars.showSuccessSnackBar(
        title: 'Success',
        message: 'OTP resent to your email',
      );
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> logout() async {
    await localStorageService.deleteKey(key: userAuthTokenKey);
    Get.offAll(() => AuthScreen());
  }

  Future<void> sendForgetPasswordEmail({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponseWithoutBody(
      '$accountsLink/$email/forgot-password',
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> res = jsonDecode(response.body);
      int data = res['data'];
      if (data == 2) {
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Email sent successfully',
        );
        Get.off(() => ForgotPasswordVerificationScreen());
      } else {
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Error sending email, Try again!',
        );
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> resendForgetPasswordEmail({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/forgot-password/resend-verification-code',
      {"emailAddress": email},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> res = jsonDecode(response.body);
      bool data = res['data'];
      if (data) {
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Email sent successfully',
        );
      } else {
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Error sending email, Try again!',
        );
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> verifyForgetPasswordOtp({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    log('otp : $otp');
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/forgot-password/verify',
      {"emailAddress": email, "validationCode": otp},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> res = jsonDecode(response.body);
      int data = res['data'];
      if (data == 1) {
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Code verification successfull',
        );
        Get.off(() => ChangePasswordScreen());
      } else {
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Invalid code or email',
        );
      }
    } else {
      dialogService.hideLoading(context);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    final response = await apiService.postWithResponse(
      '$accountsLink/$email/reset-password',
      {"emailAddress": email, "password": toBase64(password)},
      false,
    );
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      Map<String, dynamic> res = jsonDecode(response.body);
      bool data = res['data'];
      if (data) {
        dialogService.hideLoading(context);
        resetValues();
        Get.back();
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Password reset successfull',
        );
      } else {
        dialogService.hideLoading(context);
        customSnackBars.showFailureSnackBar(
          title: 'Error',
          message: 'Error re-setting password, Try again later',
        );
      }
    } else {
      dialogService.hideLoading(context);
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: 'Invalid Password',
      );
    }
  }

  Future<bool> checkUserName({required String userName}) async {
    isLoading(true);
    final response = await apiService.get(
      '$accountsLink/$userName/check-username',
      false,
      isAuth: true,
    );
    final responseData = response.$1;
    final statusCode = response.$2;
    log('Response Data : $responseData');
    
    if (responseData != null && 
        statusCode != null && 
        (statusCode == 200 || statusCode == 201) &&
        responseData['data'] == true) {
      isLoading(false);
      return true;
    } else {
      isLoading(false);
      return false;
    }
  }

  void resetValues() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    userNameController.clear();
    phoneNumController.clear();
    dobController.clear();
    otpController.clear();
    selectedDate = null;
  }

  @override
  void onInit() async {
    super.onInit();
    await dotenv.load(fileName: ".env");
    globalUsername = dotenv.env['USERNAME'];
    globalUSecret = dotenv.env['SECRET'];
    log('User name : $globalUsername');
    log('Secret : $globalUSecret');
    await getAuthToken();
  }
}
