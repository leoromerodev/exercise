import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/auth/forgot_password_screen.dart';
import 'package:heavek/views/screens/auth/signup_screen.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  
  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Auto-focus on email field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: MyText(
                  text: 'Welcome Back',
                  weight: FontWeight.w700,
                  size: 20,
                ),
              ),
              SizedBox(height: 35),
              MyTextfield(
                controller: authController.emailController,
                focusNode: _emailFocusNode,
                hint: 'test@email.com',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesEmailIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                validator: (value) => validationService.emailValidator(value),
              ),
              SizedBox(height: 24),
              MyTextfield(
                controller: authController.passwordController,
                hint: 'Password',
                isObSecure: !_isPasswordVisible,
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesPasswordIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible 
                        ? Icons.visibility_outlined 
                        : Icons.visibility_off_outlined,
                    color: Color(0xff7A8094),
                    size: 18,
                  ),
                ),
                validator: (value) => validationService.validatePassword(value),
              ),
              SizedBox(height: 18),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: MyText(
                  text: 'Forgot Password?',
                  weight: FontWeight.w400,
                  size: 14,
                  color: kHighlightColor,
                  decoration: TextDecoration.underline,
                  decorationColor: kHighlightColor,
                  onTap: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                ),
              ),
              SizedBox(height: 40),
              MyButton(
                buttonText: 'Login',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.loginEmailPassword(
                      email: authController.emailController.text.trim(),
                      password: authController.passwordController.text.trim(),
                      context: context,
                    );
                  }
                },
                radius: 5,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: 'Don\'t have an account? ',
                    color: kLightTextColor,
                    weight: FontWeight.w500,
                    size: 14,
                  ),
                  MyText(
                    text: 'Sign Up',
                    color: kHighlightColor,
                    weight: FontWeight.w500,
                    size: 14,
                    onTap: () {
                      Get.to(() => SignupScreen(fromMain: false));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
