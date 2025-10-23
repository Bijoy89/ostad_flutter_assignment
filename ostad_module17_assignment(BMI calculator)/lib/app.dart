
import 'package:flutter/material.dart';

import 'module_17/BMI_CalculatorScreen.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BMI_CalculatorScreen(),
        );
  }
}
