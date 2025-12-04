import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/password_controller.dart';
import '../models/password_entry.dart';
import 'add_edit_password_screen.dart';
import 'lock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final auth = Get.find<AuthController>();
  final passwordController = Get.find<PasswordController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  void _onTabTapped(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final isVaultTab = _tabController.index == 0;

    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xfff4f6fb),
        extendBody: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _PasswordListView(controller: passwordController, auth: auth),
                  _GeneratorView(maxWidth: constraints.maxWidth),
                ],
              );
            },
          ),
        ),
        floatingActionButton: isVaultTab
            ? FloatingActionButton(
                backgroundColor: const Color(0xff4c63f6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () => Get.to(() => AddEditPasswordScreen()),
                child: const Icon(Icons.add_rounded, size: 30),
              )
            : null,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.lock_outline,
                label: 'والت‌ها',
                selected: isVaultTab,
                onTap: () => _onTabTapped(0),
              ),
              _BottomNavItem(
                icon: Icons.password_rounded,
                label: 'سازنده رمز',
                selected: !isVaultTab,
                onTap: () => _onTabTapped(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xff4c63f6) : Colors.grey.shade500;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffe8ecff) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _PasswordListView extends StatelessWidget {
  const _PasswordListView({
    required this.controller,
    required this.auth,
  });
  final PasswordController controller;
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final isTablet = constraints.maxWidth > 700 && constraints.maxWidth <= 900;
        final horizontalPadding = isWide
            ? 32.0
            : isTablet
                ? 24.0
                : 16.0;
        final gradientHeight = (constraints.maxHeight * 0.32).clamp(220.0, 360.0);

        final gradientTop = Container(
          height: gradientHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff6f83ff), Color(0xff8ba7ff)],
            ),
          ),
        );

        return Stack(
          children: [
            gradientTop,
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 120),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    children: [
                      _HeaderCard(auth: auth, controller: controller, isWide: isWide),
                      const SizedBox(height: 12),
                      _SearchCard(
                          onChanged: (value) => controller.searchTerm.value = value,
                          dense: isWide),
                      const SizedBox(height: 12),
                      _AutoPromptCard(controller: controller, isWide: isWide),
                      const SizedBox(height: 8),
                      _VaultList(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.auth, required this.controller, this.isWide = false});
  final AuthController auth;
  final PasswordController controller;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final total = controller.entries.length;
    final recent = controller.entries.take(3).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final isStacked = constraints.maxWidth < 560;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isWide ? 22 : 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isStacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeaderBadge(),
                      const SizedBox(height: 12),
                      const _HeaderTitles(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'قفل کردن',
                          onPressed: () {
                            auth.lockApp();
                            Get.offAll(() => const LockScreen());
                          },
                          icon: const Icon(Icons.lock_outline),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HeaderBadge(),
                      const SizedBox(width: 12),
                      const Expanded(child: _HeaderTitles()),
                      IconButton(
                        tooltip: 'قفل کردن',
                        onPressed: () {
                          auth.lockApp();
                          Get.offAll(() => const LockScreen());
                        },
                        icon: const Icon(Icons.lock_outline),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDense = constraints.maxWidth < 420;
                return Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _StatPill(label: 'تعداد والت', value: '1', dense: isDense),
                    _StatPill(label: 'تعداد رمز', value: '$total', dense: isDense),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xfff8f3e8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.health_and_safety_outlined,
                              color: Color(0xfff59e0b), size: 18),
                          SizedBox(width: 6),
                          Text('سلامت خوب', style: TextStyle(color: Color(0xffd97706))),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            if (recent.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('اخیراً استفاده شده',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: recent
                    .map(
                      (e) => Chip(
                        label: Text(e.title),
                        backgroundColor: const Color(0xfff3f5ff),
                        avatar: const Icon(Icons.language, color: Color(0xff4c63f6)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _HeaderTitles extends StatelessWidget {
  const _HeaderTitles();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('سلام، خوش برگشتی',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        SizedBox(height: 4),
        Text('همه رمزهایت امن و منظم هستند', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffe8ecff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.shield_outlined, color: Color(0xff4c63f6)),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value, this.dense = false});
  final String label;
  final String value;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 12, vertical: dense ? 8 : 10),
      decoration: BoxDecoration(
        color: const Color(0xffe8ecff),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: dense ? 14 : 16)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.onChanged, this.dense = false});
  final ValueChanged<String> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'جستجو بر اساس عنوان، وبسایت یا ایمیل',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: dense ? 10 : 12, vertical: dense ? 12 : 16),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _AutoPromptCard extends StatelessWidget {
  const _AutoPromptCard({required this.controller, this.isWide = false});
  final PasswordController controller;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
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

class _VaultList extends StatelessWidget {
  const _VaultList({required this.controller});
  final PasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filteredEntries;
      if (items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text('رمزی ثبت نشده است. از دکمه + برای افزودن استفاده کنید.'),
          ),
        );
      }

      return LayoutBuilder(builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000
            ? 3
            : constraints.maxWidth > 700
                ? 2
                : 1;
        final spacing = 12.0;
        final cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;
        final itemWidth = crossAxisCount == 1 ? constraints.maxWidth : cardWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('رمزهای شما',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: items
                  .map((item) => SizedBox(
                        width: itemWidth,
                        child: _PasswordCard(entry: item, controller: controller),
                      ))
                  .toList(),
            ),
          ],
        );
      });
    });
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard({required this.entry, required this.controller});
  final PasswordEntry entry;
  final PasswordController controller;

  Future<void> _copy(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('کپی شد', '$label در کلیپ‌بورد قرار گرفت', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f5ff),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.language, color: Color(0xff4c63f6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (entry.website != null && entry.website!.isNotEmpty)
                        Text(entry.website!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => AddEditPasswordScreen(entry: entry));
                    } else if (value == 'delete') {
                      controller.deleteEntry(entry.id!);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.person_outline,
              label: 'نام کاربری',
              value: entry.username,
              onCopy: () => _copy(entry.username, 'نام کاربری'),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.lock_outline,
              label: 'رمز',
              value: '*' * (entry.password.length < 12 ? entry.password.length : 12),
              onCopy: () => _copy(entry.password, 'رمز عبور'),
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(entry.notes!, style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'کپی',
          onPressed: onCopy,
          icon: const Icon(Icons.copy, size: 18),
        ),
      ],
    );
  }
}

class _GeneratorView extends StatefulWidget {
  const _GeneratorView({required this.maxWidth});

  final double maxWidth;

  @override
  State<_GeneratorView> createState() => _GeneratorViewState();
}

class _GeneratorViewState extends State<_GeneratorView> {
  final controller = Get.find<PasswordController>();
  int _length = 16;
  bool _numbers = true;
  bool _symbols = true;
  bool _lower = true;
  bool _upper = true;
  String _generated = '';

  void _generate() {
    final result = controller.generatePassword(
      length: _length,
      useNumbers: _numbers,
      useSymbols: _symbols,
      useLowercase: _lower,
      useUppercase: _upper,
    );
    setState(() => _generated = result);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = widget.maxWidth > 900;
    final isTablet = widget.maxWidth > 700 && widget.maxWidth <= 900;
    final horizontalPadding = isWide
        ? 32.0
        : isTablet
            ? 24.0
            : 18.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isWide ? 24 : 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4c63f6), Color(0xff7d8eff)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, color: Colors.white),
                        SizedBox(width: 8),
                        Text('سازنده رمز',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: isWide ? 18 : 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              _generated.isNotEmpty
                                  ? _generated
                                  : 'اینجا رمز شما نمایش داده می‌شود',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: _generated.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey.shade500,
                                fontSize: isWide ? 18 : 16,
                              ),
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
                        _ToggleChip(
                          label: 'اعداد',
                          value: _numbers,
                          onChanged: (v) => setState(() => _numbers = v),
                        ),
                        _ToggleChip(
                          label: 'نمادها',
                          value: _symbols,
                          onChanged: (v) => setState(() => _symbols = v),
                        ),
                        _ToggleChip(
                          label: 'حروف کوچک',
                          value: _lower,
                          onChanged: (v) => setState(() => _lower = v),
                        ),
                        _ToggleChip(
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

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({required this.label, required this.value, required this.onChanged});

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
