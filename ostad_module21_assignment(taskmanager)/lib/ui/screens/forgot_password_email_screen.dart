import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'forgot_password_verify_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  static const String name = '/forgot-password-email';

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _forgotpasswordemailscreenInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const SizedBox(height: 60),

              Text(
                'Your Email Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              Text(
                'A 6-digit verification OTP will be sent to your email address',
                style: Theme.of(context).textTheme.labelMedium,
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 8),

              Visibility(
                visible: _forgotpasswordemailscreenInProgress ==false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: FilledButton(
                  onPressed: _onTapSubmitButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    text: "Have an account? ",
                    children: [
                      TextSpan(
                        style: const TextStyle(color: Colors.green),
                        text: 'Sign In',
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignInButton,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _onTapSubmitButton() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      showSnackBarMessage(context, "Email cannot be empty");
      return;
    }

    if (!EmailValidator.validate(email)) {
      showSnackBarMessage(context, "Enter a valid email");
      return;
    }

    setState(() => _forgotpasswordemailscreenInProgress = true);

    final response = await NetworkCaller.getRequest(
      Urls.recoverVerifyEmail + "/$email",
    );

    setState(() => _forgotpasswordemailscreenInProgress = false);

    if (response.isSuccess) {
      Navigator.pushNamed(
        context,
        ForgotPasswordVerifyOtpScreen.name,
        arguments: email,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage ??
          "No user found. Try again!");
    }
  }
}
