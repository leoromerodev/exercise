import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/utils/global_instances.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Automatically fetch user profile if not available
    _loadUserProfileIfNeeded();
  }

  Future<void> _loadUserProfileIfNeeded() async {
    if (userModelGlobal.value == null) {
      final userProfile = await authController.getUserProfile();
      if (userProfile != null) {
        print('Profile loaded - ProfileImage URL: ${userProfile.profileImage}');
        userModelGlobal.value = userProfile;
      }
    } else {
      print('Profile already loaded - ProfileImage URL: ${userModelGlobal.value?.profileImage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: 'Home', weight: FontWeight.w700, size: 20),
              GestureDetector(
                onTap: () async {
                  await authController.logout();
                },
                child: Icon(Icons.logout, color: kRedColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Color(0XFFE1E1E1),
                  ),
                  shape: BoxShape.circle,
                ),
                child: userModelGlobal.value?.profileImage != null && 
                       userModelGlobal.value!.profileImage!.isNotEmpty
                    ? CommonImageView(
                        url: userModelGlobal.value!.profileImage!,
                        height: 60,
                        width: 60,
                        isCircular: true,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF4A739C).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF4A739C).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: Color(0xFF4A739C).withValues(alpha: 0.6),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userModelGlobal.value != null) ...[
                      MyText(
                        text: 'Welcome, ${userModelGlobal.value?.firstName ?? 'User'}!',
                        weight: FontWeight.w600,
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      MyText(
                        text: 'Email: ${userModelGlobal.value?.email?.emailAddress ?? 'N/A'}',
                        weight: FontWeight.w400,
                        size: 12,
                        color: kLightTextColor,
                      ),
                    ] else ...[
                      MyText(
                        text: 'Loading user profile...',
                        weight: FontWeight.w400,
                        size: 14,
                        color: kLightTextColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final userProfile = await authController.getUserProfile();
              if (userProfile != null) {
                userModelGlobal.value = userProfile;
                customSnackBars.showSuccessSnackBar(
                  title: 'Success',
                  message: 'User profile loaded successfully!',
                );
              } else {
                customSnackBars.showFailureSnackBar(
                  title: 'Error',
                  message: 'Failed to load user profile',
                );
              }
            },
            child: Text('Refresh Profile'),
          ),
        ],
      ),
    );
  }
}
