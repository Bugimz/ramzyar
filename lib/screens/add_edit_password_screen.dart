import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';
import '../models/password_entry.dart';

class AddEditPasswordScreen extends StatefulWidget {
  AddEditPasswordScreen({super.key, this.entry});

  final PasswordEntry? entry;

  @override
  State<AddEditPasswordScreen> createState() => _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends State<AddEditPasswordScreen> {
  final passwordController = Get.find<PasswordController>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();
  final _notesController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry ?? Get.arguments as PasswordEntry?;
    if (entry != null) {
      _titleController.text = entry.title;
      _usernameController.text = entry.username;
      _passwordController.text = entry.password;
      _websiteController.text = entry.website ?? '';
      _notesController.text = entry.notes ?? '';
    }
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar('خطا', 'عنوان، نام کاربری و رمز عبور الزامی است');
      return;
    }

    final entry = PasswordEntry(
      id: widget.entry?.id,
      title: _titleController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: widget.entry?.createdAt,
    );

    if (widget.entry == null) {
      await passwordController.addEntry(entry);
    } else {
      await passwordController.updateEntry(entry);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fb),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: false,
        title: Text(isEditing ? 'ویرایش رمز' : 'رمز جدید'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5169f6), Color(0xff7386ff)],
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff5169f6), Color(0xff7386ff)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
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
                    padding: EdgeInsets.fromLTRB(horizontal, 10, horizontal, 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(cardPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffedf0ff),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.vpn_key, color: Color(0xff5169f6)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEditing ? 'ویرایش ورودی' : 'افزودن ورودی جدید',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'اطلاعات ورود را ذخیره کنید تا در پیشنهادهای خودکار نمایش داده شود.',
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Chip(
                                    label: Text(isEditing ? 'در حال ویرایش' : 'جدید'),
                                    backgroundColor: const Color(0xfff1f2ff),
                                    labelStyle:
                                        const TextStyle(color: Color(0xff5169f6), fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              const SizedBox(height: 18),
                              _Field(
                                controller: _titleController,
                                label: 'عنوان',
                                hint: 'مثلاً: حساب ایمیل کاری',
                                prefixIcon: Icons.badge_outlined,
                                autofillHints: const [AutofillHints.name],
                              ),
                              _Field(
                                controller: _usernameController,
                                label: 'نام کاربری / ایمیل',
                                hint: 'user@company.com',
                                prefixIcon: Icons.person_outline,
                                autofillHints: const [AutofillHints.username, AutofillHints.email],
                              ),
                              _PasswordField(
                                controller: _passwordController,
                                showPassword: _showPassword,
                                onToggle: () => setState(() => _showPassword = !_showPassword),
                                onGenerate: () {
                                  final generated = passwordController.generatePassword();
                                  _passwordController.text = generated;
                                  Clipboard.setData(ClipboardData(text: generated));
                                  Get.snackbar('رمز قوی تولید شد', 'در کلیپ‌بورد نیز کپی شد');
                                },
                              ),
                              _Field(
                                controller: _websiteController,
                                label: 'وبسایت (اختیاری)',
                                hint: 'https://example.com',
                                prefixIcon: Icons.link_outlined,
                              ),
                              _Field(
                                controller: _notesController,
                                label: 'توضیحات',
                                hint: 'نکات امنیتی یا سؤالات بازیابی',
                                maxLines: 3,
                                prefixIcon: Icons.notes_outlined,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xfff7f8fe),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.lightbulb_outline, color: Color(0xff5169f6)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'با پر کردن فیلدها، سیستم پیشنهاد و پرکردن خودکار در اندروید/iOS فعال‌تر می‌شود.',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _save,
                                  icon: const Icon(Icons.save_outlined),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff5169f6),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  label: const Text('ذخیره'),
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

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.obscure = false,
    this.maxLines = 1,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool obscure;
  final int maxLines;
  final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: const Color(0xfff3f4fb),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.showPassword,
    required this.onToggle,
    required this.onGenerate,
  });

  final TextEditingController controller;
  final bool showPassword;
  final VoidCallback onToggle;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: !showPassword,
        maxLines: 1,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          labelText: 'رمز عبور',
          hintText: 'یک رمز قوی وارد کنید یا بسازید',
          prefixIcon: const Icon(Icons.lock_outline),
          filled: true,
          fillColor: const Color(0xfff3f4fb),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: showPassword ? 'مخفی کردن' : 'نمایش',
                icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: onToggle,
              ),
              IconButton(
                tooltip: 'تولید خودکار',
                icon: const Icon(Icons.auto_fix_high_outlined),
                onPressed: onGenerate,
              ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
