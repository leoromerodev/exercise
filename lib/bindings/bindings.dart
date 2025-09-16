import 'package:get/get.dart';
import 'package:heavek/controllers/auth_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
