import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module33_assignments/presentation/provider/converter_provider.dart';
import 'package:ostad_module33_assignments/presentation/screen/converter_screen.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConverterProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unit Converter ',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: ConverterScreen(),
      ),
    );
  }
}