import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';
import '../models/password_entry.dart';

class AddEditPasswordScreen extends StatefulWidget {
  const AddEditPasswordScreen({super.key, this.entry});

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
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'رمز جدید' : 'ویرایش رمز'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final horizontal = isWide ? 32.0 : 20.0;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 28),
                child: Column(
                  children: [
                    _Field(controller: _titleController, label: 'عنوان'),
                    _Field(
                      controller: _usernameController,
                      label: 'نام کاربری / ایمیل',
                    ),
                    _Field(
                      controller: _passwordController,
                      label: 'رمز عبور',
                      obscure: true,
                    ),
                    _Field(
                      controller: _websiteController,
                      label: 'وبسایت (اختیاری)',
                    ),
                    _Field(
                      controller: _notesController,
                      label: 'توضیحات',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5169f6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('ذخیره'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    this.obscure = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
