
import 'package:flutter/material.dart';
import 'package:ostad_module38_assignment/presentation/screens/menu/widget/ava_banner.dart';
import 'package:ostad_module38_assignment/presentation/screens/menu/widget/language_toggle.dart';
import 'package:ostad_module38_assignment/presentation/screens/menu/widget/menu_item.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_strings.dart';
import '../../provider/menu_provider.dart';
import '../home/home_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: const _MenuBody(),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody();

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.bkashMenu,
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          LanguageToggle(isEnglish: menuProvider.isEnglish),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AvaBanner(),
            const Divider(height: 1, color: AppColors.divider),
            MenuItem(
              icon: Icons.home_outlined,
              label: AppStrings.home,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
            ),
            MenuItem(icon: Icons.receipt_long_outlined, label: AppStrings.statements, onTap: () {}),
            MenuItem(icon: Icons.warning_amber_outlined, label: AppStrings.limit, onTap: () {}),
            MenuItem(icon: Icons.headset_mic_outlined, label: AppStrings.customerService, onTap: () {}),
            MenuItem(icon: Icons.monetization_on_outlined, label: AppStrings.bkashMap, onTap: () {}),
            MenuItem(icon: Icons.info_outline, label: AppStrings.informationUpdate, onTap: () {}),
            MenuItem(icon: Icons.person_add_outlined, label: AppStrings.nomineeUpdate, onTap: () {}),
            MenuItem(icon: Icons.explore_outlined, label: AppStrings.discoverBkash, isNew: true, onTap: () {}),
            MenuItem(icon: Icons.share_outlined, label: AppStrings.referBkashApp, onTap: () {}),
            MenuItem(
              icon: Icons.logout,
              label: AppStrings.logOut,
              onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Version 7.0.0',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}