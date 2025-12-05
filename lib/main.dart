import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramzyar/bindings/initial_binding.dart';
import 'package:ramzyar/controllers/auth_controller.dart';
import 'package:ramzyar/controllers/theme_controller.dart';
import 'package:ramzyar/routes/app_pages.dart';
import 'package:ramzyar/routes/app_routes.dart';
import 'package:ramzyar/screens/home/home_screen.dart';
import 'package:ramzyar/screens/lock_screen.dart';
import 'package:ramzyar/screens/setup_pin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RamzYarApp());
}

class RamzYarApp extends StatelessWidget {
  const RamzYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'رمزیار',
        initialRoute: Routes.root,
        initialBinding: InitialBinding(),
        getPages: AppPages.pages,
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
        home: Obx(() {
          final auth = Get.find<AuthController>();
          if (!auth.hasPin.value) {
            return const SetupPinScreen();
          }
          if (!auth.isAuthenticated.value) {
            return const LockScreen();
          }
          return const HomeScreen();
        }),
      ),
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
      home: Obx(() {
        final auth = Get.find<AuthController>();
        if (!auth.hasPin.value) {
          return const SetupPinScreen();
        }
        if (!auth.isAuthenticated.value) {
          return const LockScreen();
        }
        return const HomeScreen();
      }),
    );
  }
}
