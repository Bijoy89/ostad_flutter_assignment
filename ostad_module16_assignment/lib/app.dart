
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'CRUD/class_2.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.deepPurple,
            primarySwatch: Colors.teal,
            //scaffold color set(sob page a hbe tkn sm color)

            //scaffoldBackgroundColor: Colors.white,

            ///all button same color
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide(color: Colors.orange, width: 1.5),

                ),
                hintStyle: TextStyle(
                  color: Colors.deepPurple,
                )
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                fontSize: 16,
              ),

            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          title: "Assignment-Module16",

          home:Crud(),

        );
      },

    );
  }
}
