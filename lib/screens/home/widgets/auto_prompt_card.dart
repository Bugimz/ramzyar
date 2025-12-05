import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/password_controller.dart';

class AutoPromptCard extends StatelessWidget {
  const AutoPromptCard({super.key, required this.controller, this.isWide = false});
  final PasswordController controller;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 7)),
        ],
      ),
      padding: EdgeInsets.all(isWide ? 20 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notifications_active_outlined, color: Color(0xff4c63f6)),
              SizedBox(width: 8),
              Text('پیشنهاد ذخیره خودکار',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'برای پیشنهاد ذخیره‌ی رمز هنگام ورود به سایت‌ها اجازه‌ی پس‌زمینه و دسترسی کلیپ‌بورد را فعال کنید.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('فعال کردن', style: TextStyle(fontWeight: FontWeight.w600)),
                Switch.adaptive(
                  value: controller.autoPromptEnabled.value,
                  activeColor: const Color(0xff4c63f6),
                  onChanged: controller.setAutoPrompt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
