import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/password_controller.dart';
import 'auto_prompt_card.dart';
import 'header_card.dart';
import 'search_card.dart';
import 'vault_list.dart';

class VaultView extends StatelessWidget {
  const VaultView({super.key, required this.controller, required this.auth});
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
                      Obx(() {
                        final items = controller.entries;
                        return HeaderCard(
                          auth: auth,
                          total: items.length,
                          recent: items.take(3).toList(),
                          isWide: isWide,
                        );
                      }),
                      const SizedBox(height: 12),
                      SearchCard(onChanged: (value) => controller.searchTerm.value = value, dense: isWide),
                      const SizedBox(height: 12),
                      AutoPromptCard(controller: controller, isWide: isWide),
                      const SizedBox(height: 8),
                      VaultList(controller: controller),
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
