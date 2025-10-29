import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();

  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();

  bool _isPasswordVisible = false;
  bool _isRetypedPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus on password field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: AppSizes.defaultPadding,
          child: Column(
            children: [
              const SizedBox(height: 120),
              Center(
                child: MyText(text: 'Enter New Password', weight: FontWeight.w700, size: 20),
              ),
              SizedBox(height: 35),
              MyTextfield(
                controller: authController.passwordController,
                focusNode: _passwordFocusNode,
                isObSecure: !_isPasswordVisible,
                hint: 'Password',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: SvgPicture.asset(
                    Assets.passwordIcon,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(kTextColorSecondary, BlendMode.srcIn),
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Color(0xff7A8094),
                    size: 18,
                  ),
                ),
                validator: (value) => validationService.validatePassword(value),
              ),
              const SizedBox(height: 10),
              MyText(
                text: '*Password must have at least 8 characters, 1 capital letter, 1 number, and 1 symbol.',
                weight: FontWeight.w500,
                size: 11,
                color: kLightTextColor,
                paddingBottom: 20,
              ),
              MyTextfield(
                controller: authController.confirmPasswordController,
                isObSecure: !_isRetypedPasswordVisible,
                hint: 'Re-type Password',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: SvgPicture.asset(
                    Assets.passwordIcon,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(kTextColorSecondary, BlendMode.srcIn),
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isRetypedPasswordVisible = !_isRetypedPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isRetypedPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Color(0xff7A8094),
                    size: 18,
                  ),
                ),
                validator: (value) =>
                    validationService.validateMatchPassword(authController.passwordController.text.trim(), value!),
              ),
              SizedBox(height: 35),
              MyButton(
                buttonText: 'Save',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.resetPassword(
                      email: authController.emailController.text.trim(),
                      password: authController.passwordController.text.trim(),
                      context: context,
                    );
                  }
                },
                radius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
