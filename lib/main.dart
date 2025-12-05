import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramzyar/routes/app_pages.dart';
import 'package:ramzyar/routes/app_routes.dart';
import 'package:ramzyar/bindings/initial_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RamzYarApp());
}

class RamzYarApp extends StatelessWidget {
  const RamzYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رمزیار',
      initialRoute: Routes.root,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5169f6)),
        useMaterial3: true,
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
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
