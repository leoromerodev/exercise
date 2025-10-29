import 'package:get/get.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/controllers/image_upload_controller.dart';
import 'package:heavek/utils/global_instances.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // Initialize services first
    initializeServices();

    Get.put<AuthController>(AuthController());
    Get.put<ImageUploadController>(ImageUploadController());
  }
}
