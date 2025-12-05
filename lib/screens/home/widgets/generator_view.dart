import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../controllers/password_controller.dart';

class GeneratorView extends StatefulWidget {
  const GeneratorView({super.key, required this.maxWidth});
  final double maxWidth;

  @override
  State<GeneratorView> createState() => _GeneratorViewState();
}

class _GeneratorViewState extends State<GeneratorView> {
  final controller = Get.find<PasswordController>();
  int _length = 16;
  bool _numbers = true;
  bool _symbols = true;
  bool _lower = true;
  bool _upper = true;
  String _generated = '';

  @override
  void initState() {
    super.initState();
    _generated = controller.generatePassword(
      length: _length,
      useNumbers: _numbers,
      useSymbols: _symbols,
      useLowercase: _lower,
      useUppercase: _upper,
    );
  }

  void _generate() {
    setState(() {
      _generated = controller.generatePassword(
        length: _length,
        useNumbers: _numbers,
        useSymbols: _symbols,
        useLowercase: _lower,
        useUppercase: _upper,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = widget.maxWidth > 900;
    final isTablet = widget.maxWidth > 700 && widget.maxWidth <= 900;
    final horizontalPadding = isWide
        ? 32.0
        : isTablet
            ? 24.0
            : 16.0;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 120),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff6f83ff), Color(0xff8ba7ff)],
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.password_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text('سازنده رمز قوی',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _generated.isEmpty ? 'حداقل یک گزینه را فعال کنید' : _generated,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _generated.length > 24 ? 20 : 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xff4c63f6)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('رمز قوی و تصادفی آماده شد'),
                                SizedBox(height: 2),
                                Text('می‌توانید آن را در کلیپ‌بورد کپی کنید',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _generated.isNotEmpty
                                ? () async {
                                    await Clipboard.setData(ClipboardData(text: _generated));
                                    Get.snackbar('کپی شد', 'رمز در کلیپ‌بورد ذخیره شد');
                                  }
                                : null,
                            icon: const Icon(Icons.copy, color: Color(0xff4c63f6)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('طول رمز', style: TextStyle(color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('$_length', style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Slider(
                      value: _length.toDouble(),
                      min: 8,
                      max: 32,
                      divisions: 24,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white54,
                      label: '$_length',
                      onChanged: (value) => setState(() => _length = value.toInt()),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ToggleChip(
                          label: 'اعداد',
                          value: _numbers,
                          onChanged: (v) => setState(() => _numbers = v),
                        ),
                        ToggleChip(
                          label: 'نمادها',
                          value: _symbols,
                          onChanged: (v) => setState(() => _symbols = v),
                        ),
                        ToggleChip(
                          label: 'حروف کوچک',
                          value: _lower,
                          onChanged: (v) => setState(() => _lower = v),
                        ),
                        ToggleChip(
                          label: 'حروف بزرگ',
                          value: _upper,
                          onChanged: (v) => setState(() => _upper = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generate,
                        icon: const Icon(Icons.refresh_rounded),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff4c63f6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        label: const Text('تولید رمز جدید'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleChip extends StatelessWidget {
  const ToggleChip({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: value ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(value ? Icons.check_circle : Icons.check_circle_outline,
                color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
