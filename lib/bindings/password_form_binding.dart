import 'package:get/get.dart';

import '../controllers/password_form_controller.dart';

class PasswordFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordFormController>(() => PasswordFormController());
  }
}
