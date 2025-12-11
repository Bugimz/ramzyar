import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// نقطه شروع برنامه رمزیار
///
/// اپلیکیشن مدیریت رمز عبور با پشتیبانی از:
/// - احراز هویت بیومتریک
/// - رمزنگاری AES-256
/// - قفل خودکار
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ThemeController باید قبل از buildِ GetMaterialApp ثبت شده باشد
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const RamzYarApp());
}

/// ویجت اصلی برنامه
class RamzYarApp extends StatelessWidget {
  const RamzYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (theme) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'رمزیار',
          initialRoute: Routes.root,
          initialBinding: InitialBinding(),
          getPages: AppPages.pages,

          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.themeMode.value,

          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: _ActivityWrapper(child: child),
            );
          },
        );
      },
    );
  }
}

/// ویجت برای ردیابی فعالیت کاربر و ریست تایمر قفل خودکار
class _ActivityWrapper extends StatelessWidget {
  const _ActivityWrapper({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // AuthController بعد از InitialBinding در دسترس است
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _markActivity(),
      onPanDown: (_) => _markActivity(),
      child: child ?? const SizedBox.shrink(),
    );
  }

  void _markActivity() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().markActivity();
    }
  }
}
