import 'package:flutter/material.dart';
import 'package:ostad_module21_assignment/ui/providers/new_task_list_provider.dart';
import 'package:ostad_module21_assignment/ui/screens/add_new_task_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/forgot_password_email_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/reset_password.dart';
import 'package:ostad_module21_assignment/ui/screens/sign_in_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/sign_up_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/splash_screen.dart';
import 'package:ostad_module21_assignment/ui/screens/update_profile_screen.dart';
import 'package:provider/provider.dart';



class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => New_task_listProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
            colorSchemeSeed: Colors.green,
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                fixedSize: Size.fromWidth(double.maxFinite),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            textTheme: TextTheme(
                titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                labelMedium: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,
                )
            ),
            scaffoldBackgroundColor: Colors.green.shade50
        ),
        routes: <String, WidgetBuilder>{
          SplashScreen.name : (_) => SplashScreen(),
          SignInScreen.name : (_) => SignInScreen(),
          SignUpScreen.name : (_) => SignUpScreen(),
          ForgotPasswordEmailScreen.name : (_) => ForgotPasswordEmailScreen(),
          ForgotPasswordVerifyOtpScreen.name : (_) => ForgotPasswordVerifyOtpScreen(),
          ResetPasswordScreen.name : (_) => ResetPasswordScreen(),
          MainBottomNavHolderScreen.name : (_) => MainBottomNavHolderScreen(),
          AddNewTaskScreen.name : (_) => AddNewTaskScreen(),
          UpdateProfileScreen.name : (_) => UpdateProfileScreen()
        },
        initialRoute: SplashScreen.name,
      ),
    );
  }
}