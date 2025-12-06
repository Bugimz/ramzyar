import 'package:get/get.dart';

import '../controllers/generator_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GeneratorController>(() => GeneratorController());
  }
}
