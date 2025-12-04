import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramzyar/screens/home_screen.dart';
import 'package:ramzyar/screens/lock_screen.dart';
import 'package:ramzyar/screens/setup_pin_screen.dart';
import 'package:ramzyar/controllers/auth_controller.dart';
import 'package:ramzyar/controllers/password_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  Get.put(PasswordController());
  runApp(const RamzYarApp());
}

class RamzYarApp extends StatelessWidget {
  const RamzYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رمزیار',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5169f6)),
        useMaterial3: true,
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: Obx(() {
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
