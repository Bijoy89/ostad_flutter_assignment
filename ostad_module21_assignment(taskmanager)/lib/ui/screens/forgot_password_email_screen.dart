import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/forgot_password_email_provider.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordEmailProvider(),
      child: Consumer<ForgotPasswordEmailProvider>(
        builder: (context, provider, _) {
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
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: !provider.inProgress,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: FilledButton(
                        onPressed: () async {
                          try {
                            await provider.verifyEmail(_emailController.text.trim());
                            Navigator.pushNamed(
                              context,
                              ForgotPasswordVerifyOtpScreen.name,
                              arguments: _emailController.text.trim(),
                            );
                          } catch (e) {
                            showSnackBarMessage(context, e.toString());
                          }
                        },
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
                                ..onTap = () => Navigator.pop(context),
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
        },
      ),
    );
  }
}
