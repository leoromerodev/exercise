import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/services/user_service/user_service.dart';
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

  // Get reference to UserService
  final UserService _userService = UserService.instance;

  Future<void> getAuthToken() async {
    final response = await _userService.getAuthToken(
      username: globalUsername!,
      secret: globalUSecret!,
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
    
    final (data, statusCode) = await _userService.checkAccountStatus(email: email);
    
    if (statusCode != null && data != null &&
        (statusCode == 200 || statusCode == 201)) {
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
    
    // Clear any existing user data to prevent old data persistence
    clearUserGlobalState();
    
    // Step 1: Sign up with email and password
    final (signupSuccess, signupStatusCode) = await _userService.signupWithEmailPassword(
      email: email,
      password: toBase64(password),
    );
    
    if (signupSuccess && signupStatusCode != null &&
        (signupStatusCode == 200 || signupStatusCode == 201)) {
      
      // Step 2: Login and get auth token
      final (authToken, loginStatusCode) = await _userService.loginAndGetAuthToken(
        email: email,
        password: toBase64(password),
      );

      if (authToken != null && loginStatusCode != null &&
          (loginStatusCode == 200 || loginStatusCode == 201)) {
        
        // Store auth token
        await localStorageService.writeString(
          key: userAuthTokenKey,
          value: authToken,
        );

        // Step 3: Get user profile
        final userProfile = await _userService.getUserProfileWithAuth(
          email: email,
        );
        
        if (userProfile != null && 
            (userProfile.statusCode == 200 || userProfile.statusCode == 201)) {
          userModelGlobal.value = userProfile;
          
          if ((userModelGlobal.value?.firstName?.isEmpty ?? true) ||
              (userModelGlobal.value?.screenName?.isEmpty ?? true)) {
            dialogService.hideLoading(context);
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
    
    final (data, baseModel) = await _userService.verifyEmailOtp(
      email: email,
      otp: otp,
    );
    
    if (baseModel != null && data != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
      if (data == 1) {
        // Verification Success
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Code Verified Successfully.',
        );
        otpController.clear();
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
    
    // Clear any existing user data to prevent old data persistence
    clearUserGlobalState();
    
    // Step 1: Login and get auth token
    final (authToken, loginStatusCode) = await _userService.loginAndGetAuthToken(
      email: email,
      password: toBase64(password),
    );
    
    log('login res code : $loginStatusCode');

    if (authToken!= null && loginStatusCode != null &&
        (loginStatusCode == 200 || loginStatusCode == 201)) {
      
      // Store auth token
      await localStorageService.writeString(
        key: userAuthTokenKey,
        value: authToken,
      );

      // Step 2: Get user profile
      final userProfile = await _userService.getUserProfileWithAuth(
        email: email,
      );
      
      if (userProfile != null &&
          (userProfile.statusCode == 200 || userProfile.statusCode == 201)) {
        userModelGlobal.value = userProfile;
        
        if ((userModelGlobal.value?.firstName?.isEmpty ?? true) ||
            (userModelGlobal.value?.screenName?.isEmpty ?? true)) {
          passwordController.clear();
          dialogService.hideLoading(context);
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
    
    final userProfile = await _userService.completeUserProfile(user: user);

    if (userProfile != null && 
        (userProfile.statusCode == 200 || userProfile.statusCode == 201)) {
      userModelGlobal.value = userProfile;
      
      dialogService.hideLoading(context);
      customSnackBars.showSuccessSnackBar(
        title: 'Success',
        message: 'Profile updated successfully.',
      );
      resetValues();
      Get.offAll(() => BottomNavBar());
    } else {
      dialogService.hideLoading(context);
      
      // Extract error messages from UserModel (since it inherits from BaseModel)
      String errorMessage = 'Profile update failed';
      if (userProfile != null && userProfile.messages.isNotEmpty) {
        errorMessage = userProfile.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<void> resendOtp({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    
    final baseModel = await _userService.resendOtp(email: email);
    
    if (baseModel != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
      dialogService.hideLoading(context);
      customSnackBars.showSuccessSnackBar(
        title: 'Success',
        message: 'OTP resent to your email',
      );
    } else {
      dialogService.hideLoading(context);
      
      // Extract error messages from BaseModel if available
      String errorMessage = 'Failed to resend OTP';
      if (baseModel != null && baseModel.messages.isNotEmpty) {
        errorMessage = baseModel.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<void> logout() async {
    // Clear stored auth token
    await localStorageService.deleteKey(key: userAuthTokenKey);
    
    // Clear global user model to prevent old data persistence
    userModelGlobal.value = null;
    
    Get.offAll(() => AuthScreen());
  }

  Future<void> sendForgetPasswordEmail({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    
    final (data, baseModel) = await _userService.sendForgotPasswordEmail(email: email);
    
    if (baseModel != null && data != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
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
      
      // Extract error messages from BaseModel if available
      String errorMessage = 'Error sending email, Try again!';
      if (baseModel != null && baseModel.messages.isNotEmpty) {
        errorMessage = baseModel.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<void> resendForgetPasswordEmail({
    required String email,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    
    final (data, baseModel) = await _userService.resendForgotPasswordEmail(email: email);
    
    if (baseModel != null && data != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
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
      
      // Extract error messages from BaseModel if available
      String errorMessage = 'Error sending email, Try again!';
      if (baseModel != null && baseModel.messages.isNotEmpty) {
        errorMessage = baseModel.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<void> verifyForgetPasswordOtp({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    log('otp : $otp');
    dialogService.showProgressDialog(context: context);
    
    final (data, baseModel) = await _userService.verifyForgotPasswordOtp(
      email: email,
      otp: otp,
    );
    
    if (baseModel != null && data != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
      if (data == 1) {
        dialogService.hideLoading(context);
        customSnackBars.showSuccessSnackBar(
          title: 'Success',
          message: 'Code verification successfull',
        );
        otpController.clear();
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
      
      // Extract error messages from BaseModel if available
      String errorMessage = 'Invalid code or email';
      if (baseModel != null && baseModel.messages.isNotEmpty) {
        errorMessage = baseModel.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    dialogService.showProgressDialog(context: context);
    
    final (data, baseModel) = await _userService.resetForgotPassword(
      email: email,
      password: toBase64(password),
    );
    
    if (baseModel != null && data != null &&
        (baseModel.statusCode == 200 || baseModel.statusCode == 201)) {
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
      
      // Extract error messages from BaseModel if available
      String errorMessage = 'Invalid Password';
      if (baseModel != null && baseModel.messages.isNotEmpty) {
        errorMessage = baseModel.messages.join('\n');
      }
      
      customSnackBars.showFailureSnackBar(
        title: 'Error',
        message: errorMessage,
      );
    }
  }

  Future<bool> checkUserName({required String userName}) async {
    isLoading(true);
    
    final (data, baseModel) = await _userService.checkUsernameAvailability(
      username: userName,
    );
    
    log('Response Data : $data');
    
    if (baseModel != null && data != null && 
        (baseModel.statusCode == 200 || baseModel.statusCode == 201) &&
        data == true) {
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

  void clearUserGlobalState() {
    userModelGlobal.value = null;
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
