
import 'package:flutter/material.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../../menu/menu_screen.dart';
import '../../profile/profile_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tapping avatar goes to Profile
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const _BalanceCheck(),
                ],
              ),
            ],
          ),
        ),

        // Right side: search + menu
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.white),
              onPressed: () {},
            ),

            // Tapping this goes to Menu
            IconButton(
              icon: Image.asset(
                'assets/bkash.png',
                color: AppColors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceCheck extends StatelessWidget {
  const _BalanceCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
      ),
      child: Row(
        children: [
          Container(
            height: 16,
            width: 16,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '৳',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Text(AppStrings.tapForBalance, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
