import 'package:flutter/material.dart';

class HelpSection {
  const HelpSection({
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

const List<HelpSection> helpSections = [
  HelpSection(
    title: 'شروع سریع',
    body:
        'پس از تنظیم پین، می‌توانید ورود بیومتریک را فعال کنید تا هر بار به محض باز کردن اپ با اثر انگشت یا چهره وارد شوید.',
    icon: Icons.rocket_launch_outlined,
    chips: ['پین', 'بیومتریک', 'ورود سریع'],
  ),
  HelpSection(
    title: 'ذخیره و مدیریت رمزها',
    body:
        'از تب والت برای مشاهده، جستجو و کپی رمزها استفاده کنید. با دکمه + کارت جدید بسازید یا رمز تصادفی از تب سازنده تولید و ذخیره کنید.',
    icon: Icons.lock_person_outlined,
    chips: ['والت', 'جستجو', 'ذخیره امن'],
  ),
  HelpSection(
    title: 'مانیتور پس‌زمینه و اعلان',
    body:
        'فعال‌سازی «پایش کلیپ‌بورد/فرم» باعث می‌شود سرویس پس‌زمینه هنگام کپی رمز یا پر کردن فرم پیشنهادی برای ذخیره نمایش دهد. مطمئن شوید مجوز باتری را صادر کرده‌اید.',
    icon: Icons.notifications_active_outlined,
    chips: ['پس‌زمینه', 'مجوز باتری', 'پیشنهاد ذخیره'],
  ),
  HelpSection(
    title: 'اتو‌فیل اندروید/iOS',
    body:
        'از بخش تنظیمات امنیتی وارد «راهنمای کامل» شوید و از آنجا به تنظیمات سیستم برای فعال کردن سرویس Auto-fill هدایت می‌شوید. فرم‌ها با پرچم‌های autofill آماده پیشنهاد هستند.',
    icon: Icons.auto_fix_high_outlined,
    chips: ['Auto-fill', 'فرم‌ها', 'اندروید/iOS'],
  ),
  HelpSection(
    title: 'قفل خودکار و حالت شب',
    body:
        'زمان قفل خودکار را بین ۱ تا ۳۰ دقیقه تنظیم کنید. حالت شب یا روشن را از تنظیمات امنیتی عوض کنید تا رنگ‌بندی سازگار با محیط داشته باشید.',
    icon: Icons.dark_mode_outlined,
    chips: ['قفل خودکار', 'حالت شب', 'امنیت'],
  ),
  HelpSection(
    title: 'محدودیت اسکرین‌شات',
    body:
        'برای جلوگیری از ضبط یا اسکرین‌شات از محتوای محرمانه، سوئیچ «محدودیت اسکرین‌شات» را روشن کنید. هر زمان نیاز داشتید می‌توانید آن را خاموش کنید.',
    icon: Icons.shield_outlined,
    chips: ['محافظت صفحه', 'ضبط صفحه', 'حریم خصوصی'],
  ),
];
