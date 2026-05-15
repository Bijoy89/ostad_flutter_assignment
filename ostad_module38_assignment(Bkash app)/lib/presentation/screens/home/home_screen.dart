
import 'package:flutter/material.dart';
import 'package:ostad_module38_assignment/presentation/screens/home/widget/home_app_bar.dart';
import 'package:ostad_module38_assignment/presentation/screens/home/widget/menu_grid.dart';

import '../../../core/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: const HomeAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MenuGrid(),
            Image.asset('assets/offfer_banner.png'),
          ],
        ),
      ),
    );
  }
}