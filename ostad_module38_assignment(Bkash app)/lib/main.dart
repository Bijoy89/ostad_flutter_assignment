
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module38_assignment/presentation/provider/home_provider.dart';
import 'package:ostad_module38_assignment/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: MaterialApp(
        title: 'Bkash App',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}