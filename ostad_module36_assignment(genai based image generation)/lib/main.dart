
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module36_assignment/presentation/provider/chat_provider.dart';
import 'package:ostad_module36_assignment/presentation/provider/image_gen_provider.dart';
import 'package:ostad_module36_assignment/presentation/screens/splash_screen.dart';

import 'package:provider/provider.dart';


void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ImageGenProvider()),
      ],
      child: MaterialApp(
        title: 'AI Chat App with Image Generation',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: SplashScreen(),
      ),
    );
  }
}