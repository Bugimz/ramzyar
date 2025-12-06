import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/help_controller.dart';
import 'widgets/help_card.dart';

class HelpScreen extends GetView<HelpController> {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            child: Obx(() {
              final items = controller.sections;
              return GridView.builder(
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return HelpCard(section: items[index], textTheme: textTheme);
                },
              );
            }),
          );
        },
      ),
    );
  }
}
