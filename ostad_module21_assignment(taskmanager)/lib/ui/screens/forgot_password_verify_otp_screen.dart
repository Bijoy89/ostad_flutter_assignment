import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/forgot_password_verify_otp_provider.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import 'reset_password.dart';
import 'sign_in_screen.dart';

class ForgotPasswordVerifyOtpScreen extends StatelessWidget {
  const ForgotPasswordVerifyOtpScreen({super.key});

  static const String name = '/forgot-password-verify-otp';

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    final TextEditingController _otpController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordVerifyOtpProvider(),
      child: Consumer<ForgotPasswordVerifyOtpProvider>(
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
                      'OTP Verification',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A 6-digit verification OTP has been sent to your email address',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    PinCodeTextField(
                      controller: _otpController,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      appContext: context,
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: !provider.inProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: FilledButton(
                        onPressed: () async {
                          String otp = _otpController.text.trim();
                          if (otp.isEmpty) {
                            showSnackBarMessage(context, "OTP cannot be empty");
                            return;
                          }
                          try {
                            await provider.verifyOtp(email, otp);
                            Navigator.pushNamed(
                              context,
                              ResetPasswordScreen.name,
                              arguments: {"email": email, "otp": otp},
                            );
                          } catch (e) {
                            showSnackBarMessage(context, e.toString());
                          }
                        },
                        child: const Text('Verify'),
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
                                ..onTap = () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, SignInScreen.name, (predicate) => false);
                                },
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
