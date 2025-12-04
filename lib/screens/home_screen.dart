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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xfff2f4f8),
        appBar: AppBar(
          title: const Text('رمزیار'),
          actions: [
            IconButton(
              tooltip: 'قفل کردن',
              onPressed: () {
                auth.lockApp();
                Get.offAll(() => const LockScreen());
              },
              icon: const Icon(Icons.lock_outline),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: const Color(0xff5169f6),
            tabs: const [
              Tab(text: 'رمزها'),
              Tab(text: 'سازنده رمز'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _PasswordListView(controller: passwordController),
            const _GeneratorView(),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton.extended(
                onPressed: () => Get.to(() => AddEditPasswordScreen()),
                icon: const Icon(Icons.add),
                label: const Text('افزودن رمز'),
              )
            : null,
      ),
    );
  }
}

class _PasswordListView extends StatelessWidget {
  const _PasswordListView({required this.controller});
  final PasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'جستجو بر اساس عنوان، وبسایت یا ایمیل',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              onChanged: (value) => controller.searchTerm.value = value,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: const Color(0xff5169f6),
            child: const ListTile(
              title: Text('در پس‌زمینه فعال بمان', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'برای دریافت اعلان ذخیره رمز هنگام ورود یا ثبت‌نام در سایت‌ها، اجازه پس‌زمینه را فعال کنید.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => SwitchListTile(
              title: const Text('پیشنهاد ذخیره خودکار'),
              subtitle: const Text('بررسی حافظه موقت برای پیشنهاد ذخیره‌سازی شبیه Samsung Pass'),
              value: controller.autoPromptEnabled.value,
              onChanged: controller.setAutoPrompt,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final items = controller.filteredEntries;
              if (items.isEmpty) {
                return const Center(
                  child: Text('رمزی ثبت نشده است. از دکمه + برای افزودن استفاده کنید.'),
                );
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _PasswordCard(entry: item, controller: controller);
                },
              );
            }),
          ),
        ],
      ),
    );
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (entry.website != null && entry.website!.isNotEmpty)
                      Text(entry.website!, style: const TextStyle(color: Colors.grey)),
                  ],
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(child: Text(entry.username)),
                IconButton(
                  onPressed: () => _copy(entry.username, 'نام کاربری'),
                  icon: const Icon(Icons.copy, size: 18),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(child: Text('*' * (entry.password.length < 8 ? entry.password.length : 8))),
                IconButton(
                  onPressed: () => _copy(entry.password, 'رمز عبور'),
                  icon: const Icon(Icons.copy, size: 18),
                ),
              ],
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(entry.notes!, style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

class _GeneratorView extends StatefulWidget {
  const _GeneratorView();

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('رمز قوی بسازید', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _length.toDouble(),
                        min: 8,
                        max: 32,
                        divisions: 24,
                        label: '$_length کاراکتر',
                        onChanged: (value) => setState(() => _length = value.toInt()),
                      ),
                    ),
                    Text('$_length'),
                  ],
                ),
                CheckboxListTile(
                  value: _numbers,
                  onChanged: (value) => setState(() => _numbers = value ?? false),
                  title: const Text('اعداد'),
                ),
                CheckboxListTile(
                  value: _symbols,
                  onChanged: (value) => setState(() => _symbols = value ?? false),
                  title: const Text('نمادها'),
                ),
                CheckboxListTile(
                  value: _lower,
                  onChanged: (value) => setState(() => _lower = value ?? false),
                  title: const Text('حروف کوچک'),
                ),
                CheckboxListTile(
                  value: _upper,
                  onChanged: (value) => setState(() => _upper = value ?? false),
                  title: const Text('حروف بزرگ'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5169f6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('تولید رمز'),
                  ),
                ),
              ],
            ),
          ),
          if (_generated.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('رمز ساخته شده'),
                    const SizedBox(height: 8),
                    SelectableText(
                      _generated,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: _generated));
                          Get.snackbar('کپی شد', 'رمز در کلیپ‌بورد ذخیره شد');
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
