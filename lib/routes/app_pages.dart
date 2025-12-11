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

/// تعریف صفحات و مسیرهای برنامه
///
/// هر GetPage شامل route، page و binding مربوطه است.
/// توجه: InitialBinding در main.dart کنترلرهای اصلی را ثبت می‌کند.
class AppPages {
  static final pages = <GetPage<dynamic>>[
    // Root router - تصمیم‌گیری برای نمایش setup/lock/home
    GetPage(
      name: Routes.root,
      page: () => const RootRouter(),
      // فقط binding‌های مورد نیاز برای root
      bindings: [SetupPinBinding(), LockBinding(), HomeBinding()],
    ),

    // صفحه تنظیم PIN اولیه
    GetPage(
      name: Routes.setupPin,
      page: () => const SetupPinScreen(),
      // استفاده از کنترلر موجود - بدون binding تکراری
    ),

    // صفحه قفل
    GetPage(name: Routes.lock, page: () => const LockScreen()),

    // صفحه اصلی
    GetPage(name: Routes.home, page: () => const HomeScreen()),

    // فرم افزودن/ویرایش پسورد
    GetPage(
      name: Routes.addEditPassword,
      page: () => AddEditPasswordScreen(),
      binding: PasswordFormBinding(),
    ),

    // صفحه راهنما
    GetPage(
      name: Routes.help,
      page: () => const HelpScreen(),
      binding: HelpBinding(),
    ),
  ];
}
