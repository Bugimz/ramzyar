import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final auth = Get.find<AuthController>();
  bool _saving = false;
  String? _error;
  bool _showPin = false;
  bool _showConfirm = false;

  Future<void> _savePin() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.length < 4) {
      setState(() => _error = 'حداقل چهار رقم وارد کنید');
      return;
    }
    if (pin != confirm) {
      setState(() => _error = 'رمزها یکسان نیستند');
      return;
    }

    setState(() => _saving = true);
    await auth.setPin(pin);
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 640;
            final horizontal = isWide ? 48.0 : 22.0;
            final cardPadding = isWide ? 32.0 : 20.0;

            return Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -120,
                  left: -120,
                  child: Container(
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff5169f6), Color(0xff7289ff)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        bottomRight: Radius.circular(48),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.shield_lock_rounded,
                                    color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'راه‌اندازی امنیتی',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Chip(
                                backgroundColor: Colors.white.withOpacity(0.18),
                                label: const Text(
                                  'مرحله ۱ از ۱',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'انتخاب پین ۴ رقمی',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'این پین برای ورود سریع و رمزگذاری داده‌های شما استفاده می‌شود. '
                                    'بعداً می‌توانید ورود بیومتریک را هم فعال کنید.',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: const [
                                      _HintBadge(icon: Icons.timer, text: 'قفل خودکار قابل تنظیم'),
                                      SizedBox(width: 8),
                                      _HintBadge(icon: Icons.phonelink_lock, text: 'جلوگیری از اسکرین‌شات'),
                                    ],
                                  ),
                                  const SizedBox(height: 28),
                                  _PinField(
                                    controller: _pinController,
                                    label: 'رمز عبور',
                                    showText: _showPin,
                                    onToggleVisibility: () =>
                                        setState(() => _showPin = !_showPin),
                                  ),
                                  const SizedBox(height: 14),
                                  _PinField(
                                    controller: _confirmController,
                                    label: 'تکرار رمز عبور',
                                    showText: _showConfirm,
                                    onToggleVisibility: () =>
                                        setState(() => _showConfirm = !_showConfirm),
                                  ),
                                  const SizedBox(height: 10),
                                  if (_error != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        _error!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  const Spacer(),
                                  Row(
                                    children: const [
                                      Icon(Icons.info_outline, color: Color(0xff5169f6)),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'پین شما فقط روی این دستگاه و به صورت رمزگذاری‌شده نگهداری می‌شود.',
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _saving ? null : _savePin,
                                      icon: _saving
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(Icons.check_circle_outline),
                                      label: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Text(
                                          _saving ? 'در حال ذخیره...' : 'تأیید و ادامه',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff5169f6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  const _PinField({
    required this.controller,
    required this.label,
    required this.showText,
    required this.onToggleVisibility,
  });

  final TextEditingController controller;
  final String label;
  final bool showText;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !showText,
      keyboardType: TextInputType.number,
      maxLength: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff2f4f9),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(showText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        labelText: label,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffd8ddf3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff5169f6), width: 1.6),
        ),
      ),
    );
  }
}

class _HintBadge extends StatelessWidget {
  const _HintBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: const Color(0xffeef1fb),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      avatar: Icon(icon, color: const Color(0xff5169f6), size: 18),
      label: Text(
        text,
        style: const TextStyle(color: Color(0xff5169f6)),
      ),
    );
  }
}
