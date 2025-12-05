import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final sections = [
      _HelpSection(
        title: 'شروع سریع',
        body:
            'پس از تنظیم پین، می‌توانید ورود بیومتریک را فعال کنید تا هر بار به محض باز کردن اپ با اثر انگشت یا چهره وارد شوید.',
        icon: Icons.rocket_launch_outlined,
        chips: const ['پین', 'بیومتریک', 'ورود سریع'],
      ),
      _HelpSection(
        title: 'ذخیره و مدیریت رمزها',
        body:
            'از تب والت برای مشاهده، جستجو و کپی رمزها استفاده کنید. با دکمه + کارت جدید بسازید یا رمز تصادفی از تب سازنده تولید و ذخیره کنید.',
        icon: Icons.lock_person_outlined,
        chips: const ['والت', 'جستجو', 'ذخیره امن'],
      ),
      _HelpSection(
        title: 'مانیتور پس‌زمینه و اعلان',
        body:
            'فعال‌سازی «پایش کلیپ‌بورد/فرم» باعث می‌شود سرویس پس‌زمینه هنگام کپی رمز یا پر کردن فرم پیشنهادی برای ذخیره نمایش دهد. مطمئن شوید مجوز باتری را صادر کرده‌اید.',
        icon: Icons.notifications_active_outlined,
        chips: const ['پس‌زمینه', 'مجوز باتری', 'پیشنهاد ذخیره'],
      ),
      _HelpSection(
        title: 'اتو‌فیل اندروید/iOS',
        body:
            'از بخش تنظیمات امنیتی وارد «راهنمای کامل» شوید و از آنجا به تنظیمات سیستم برای فعال کردن سرویس Auto-fill هدایت می‌شوید. فرم‌ها با پرچم‌های autofill آماده پیشنهاد هستند.',
        icon: Icons.auto_fix_high_outlined,
        chips: const ['Auto-fill', 'فرم‌ها', 'اندروید/iOS'],
      ),
      _HelpSection(
        title: 'قفل خودکار و حالت شب',
        body:
            'زمان قفل خودکار را بین ۱ تا ۳۰ دقیقه تنظیم کنید. حالت شب یا روشن را از تنظیمات امنیتی عوض کنید تا رنگ‌بندی سازگار با محیط داشته باشید.',
        icon: Icons.dark_mode_outlined,
        chips: const ['قفل خودکار', 'حالت شب', 'امنیت'],
      ),
      _HelpSection(
        title: 'محدودیت اسکرین‌شات',
        body:
            'برای جلوگیری از ضبط یا اسکرین‌شات از محتوای محرمانه، سوئیچ «محدودیت اسکرین‌شات» را روشن کنید. هر زمان نیاز داشتید می‌توانید آن را خاموش کنید.',
        icon: Icons.shield_lock_outlined,
        chips: const ['محافظت صفحه', 'ضبط صفحه', 'حریم خصوصی'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای استفاده'),
        actions: [
          IconButton(
            tooltip: 'بازگشت',
            onPressed: Get.back,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final isMedium = constraints.maxWidth > 640;
          final crossAxisCount = isWide
              ? 3
              : isMedium
                  ? 2
                  : 1;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 20,
              vertical: isWide ? 24 : 16,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide
                    ? 1.2
                    : isMedium
                        ? 1.1
                        : 1.05,
              ),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return _HelpCard(section: section, textTheme: textTheme);
              },
            ),
          );
        },
      ),
    );
  }
}

class _HelpSection {
  const _HelpSection({
    required this.title,
    required this.body,
    required this.icon,
    required this.chips,
  });

  final String title;
  final String body;
  final IconData icon;
  final List<String> chips;
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.section, required this.textTheme});

  final _HelpSection section;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(section.icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 12),
          Text(
            section.title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: section.chips
                .map(
                  (c) => Chip(
                    label: Text(c),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: colorScheme.secondaryContainer,
                    labelStyle:
                        textTheme.labelMedium?.copyWith(color: colorScheme.onSecondaryContainer),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
