
import 'package:flutter/material.dart';
import 'package:ostad_module19_assignment/weather_screen.dart';



class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WeatherScreen(),
    );
  }
}
