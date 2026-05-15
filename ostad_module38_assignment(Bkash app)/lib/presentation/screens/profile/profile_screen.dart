
import 'package:flutter/material.dart';
import 'package:ostad_module38_assignment/presentation/screens/profile/widget/nav_item.dart';
import 'package:ostad_module38_assignment/presentation/screens/profile/widget/profile_header.dart';
import 'package:ostad_module38_assignment/presentation/screens/profile/widget/section_header.dart';
import 'package:ostad_module38_assignment/presentation/screens/profile/widget/toggle_item.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_strings.dart';
import '../../provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/bkash.png',
              color: AppColors.white,
              colorBlendMode: BlendMode.srcIn,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(profile: provider.profile),
            const SizedBox(height: 16),

            const SectionHeader(title: AppStrings.setTransactionFeatures),
            ToggleItem(
              icon: Icons.touch_app_outlined,
              label: AppStrings.oneTapTransaction,
              value: provider.oneTapTransaction,
              onChanged: (_) => provider.toggleOneTapTransaction(),
            ),
            NavItem(icon: Icons.nfc_outlined, label: AppStrings.bkashNfc, onTap: () {}),
            NavItem(icon: Icons.credit_card_outlined, label: AppStrings.savedCards, onTap: () {}),
            NavItem(icon: Icons.apps_outlined, label: AppStrings.linkedApps, onTap: () {}),
            ToggleItem(
              icon: Icons.fingerprint,
              label: AppStrings.touchFaceId,
              value: provider.touchFaceId,
              onChanged: (_) => provider.toggleTouchFaceId(),
            ),

            const SizedBox(height: 8),
            const SectionHeader(title: AppStrings.selectYourPreferences),
            NavItem(icon: Icons.palette_outlined, label: AppStrings.selectTheme, onTap: () {}),
            NavItem(icon: Icons.notifications_outlined, label: AppStrings.notificationManagement, onTap: () {}),

            const SizedBox(height: 8),
            const SectionHeader(title: AppStrings.manageYourAccount),
            NavItem(icon: Icons.swap_horiz_outlined, label: AppStrings.updateBkashNumber, onTap: () {}),
            NavItem(icon: Icons.more_horiz_outlined, label: AppStrings.others, onTap: () {}),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}