import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/password_form_controller.dart';
import '../../routes/app_routes.dart';
import '../../models/password_entry.dart';
import 'widgets/password_header.dart';
import 'widgets/password_secret_field.dart';
import 'widgets/password_text_field.dart';
import 'widgets/password_tips.dart';

class AddEditPasswordScreen extends GetView<PasswordFormController> {
  const AddEditPasswordScreen({super.key, this.entry});

  final PasswordEntry? entry;

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing || entry != null;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffold = Theme.of(context).scaffoldBackgroundColor;

    // push the entry into the controller only once
    if (entry != null && controller.entry == null) {
      controller.entry = entry;
      controller
        ..titleController.text = entry!.title
        ..usernameController.text = entry!.username
        ..passwordController.text = entry!.password
        ..websiteController.text = entry!.website ?? ''
        ..notesController.text = entry!.notes ?? '';
    }

    return Scaffold(
      backgroundColor: scaffold,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: false,
        title: Text(isEditing ? 'ویرایش رمز' : 'رمز جدید'),
        actions: [
          IconButton(
            tooltip: 'کمک',
            onPressed: () => Get.toNamed(Routes.help),
            icon: const Icon(Icons.help_outline),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 760;
          final horizontal = isWide ? 38.0 : 18.0;
          final cardPadding = isWide ? 28.0 : 18.0;

          return Stack(
            children: [
              Positioned(
                top: -80,
                left: -40,
                right: -80,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      10,
                      horizontal,
                      28,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(cardPadding),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 0.32
                                      : 0.06,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PasswordHeader(
                                isEditing: isEditing,
                                textTheme: textTheme,
                                colorScheme: colorScheme,
                              ),
                              const SizedBox(height: 18),
                              PasswordTextField(
                                controller: controller.titleController,
                                label: 'عنوان',
                                hint: 'مثلاً: حساب ایمیل کاری',
                                prefixIcon: Icons.badge_outlined,
                                autofillHints: const [AutofillHints.name],
                              ),
                              PasswordTextField(
                                controller: controller.usernameController,
                                label: 'نام کاربری / ایمیل',
                                hint: 'user@company.com',
                                prefixIcon: Icons.person_outline,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                              ),
                              Obx(
                                () => PasswordSecretField(
                                  controller: controller.passwordController,
                                  showPassword: controller.showPassword.value,
                                  onToggle: controller.showPassword.toggle,
                                  onGenerate: () {
                                    final generated = controller.passwords
                                        .generatePassword();
                                    controller.passwordController.text =
                                        generated;
                                    Clipboard.setData(
                                      ClipboardData(text: generated),
                                    );
                                    Get.snackbar(
                                      'رمز قوی تولید شد',
                                      'در کلیپ‌بورد نیز کپی شد',
                                    );
                                  },
                                ),
                              ),
                              PasswordTextField(
                                controller: controller.websiteController,
                                label: 'وبسایت (اختیاری)',
                                hint: 'https://example.com',
                                prefixIcon: Icons.link_outlined,
                              ),
                              PasswordTextField(
                                controller: controller.notesController,
                                label: 'توضیحات',
                                hint: 'نکات امنیتی یا سؤالات بازیابی',
                                maxLines: 3,
                                prefixIcon: Icons.notes_outlined,
                              ),
                              const SizedBox(height: 10),
                              PasswordTips(textTheme: textTheme),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: controller.save,
                                  icon: const Icon(Icons.save_outlined),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  label: Text(
                                    'ذخیره',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
