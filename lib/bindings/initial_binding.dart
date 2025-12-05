import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/password_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<PasswordController>(PasswordController(), permanent: true);
  }
}
