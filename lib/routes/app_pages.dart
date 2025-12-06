import 'package:get/get.dart';

import '../bindings/help_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/lock_binding.dart';
import '../bindings/password_form_binding.dart';
import '../bindings/setup_pin_binding.dart';
import '../screens/help/help_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/lock/lock_screen.dart';
import '../screens/password_form/password_form_screen.dart';
import '../screens/root_router.dart';
import '../screens/setup_pin/setup_pin_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: Routes.root,
      page: () => const RootRouter(),
      bindings: [
        SetupPinBinding(),
        LockBinding(),
        HomeBinding(),
        PasswordFormBinding(),
      ],
    ),
    GetPage(
      name: Routes.setupPin,
      page: () => const SetupPinScreen(),
      binding: SetupPinBinding(),
    ),
    GetPage(
      name: Routes.lock,
      page: () => const LockScreen(),
      binding: LockBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.addEditPassword,
      page: () => AddEditPasswordScreen(),
      binding: PasswordFormBinding(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpScreen(),
      binding: HelpBinding(),
    ),
  ];
}
