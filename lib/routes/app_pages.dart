import 'package:get/get.dart';

import '../bindings/initial_binding.dart';
import '../screens/add_edit_password_screen.dart';
import '../screens/help_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/lock_screen.dart';
import '../screens/root_router.dart';
import '../screens/setup_pin_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: Routes.root,
      page: () => const RootRouter(),
      binding: InitialBinding(),
    ),
    GetPage(name: Routes.setupPin, page: () => const SetupPinScreen()),
    GetPage(name: Routes.lock, page: () => const LockScreen()),
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(
      name: Routes.addEditPassword,
      page: () => AddEditPasswordScreen(),
    ),
    GetPage(name: Routes.help, page: () => const HelpScreen()),
  ];
}
