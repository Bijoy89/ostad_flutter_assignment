import 'package:flutter/material.dart';
import 'package:ostad_module31_assignment/presentation/home/screen/home_screen.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Lite',
      theme: ThemeData(

        colorScheme: ColorScheme.dark(
          primary: AppColors.youtubePrimary,
          surface: AppColors.surfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
      ),
      home:  HomeScreen(),
    );
  }
}
