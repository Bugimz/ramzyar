import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/home/home_screen.dart';
import 'screens/lock_screen.dart';
import 'screens/setup_pin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ThemeController باید قبل از buildِ GetMaterialApp ثبت شده باشد
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const RamzYarApp());
}

class RamzYarApp extends StatelessWidget {
  const RamzYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    // ✅ حالا Obx درست استفاده می‌شود: فقط یک Widget برمی‌گرداند
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'رمزیار',
        initialBinding: InitialBinding(),

        theme: theme.lightTheme,
        darkTheme: theme.darkTheme,
        themeMode: theme.themeMode.value,

        builder: (context, child) {
          final auth = Get.find<AuthController>();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: auth.markActivity,
              onPanDown: (_) => auth.markActivity(),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },

        home: const RootGate(),
      );
    });
  }
}

class RootGate extends GetView<AuthController> {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasPin.value) return const SetupPinScreen();
      if (!controller.isAuthenticated.value) return const LockScreen();
      return const HomeScreen();
    });
  }
}
