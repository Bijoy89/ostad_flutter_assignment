import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module21_assignment/ui/screens/reset_password.dart';
import 'package:ostad_module21_assignment/ui/screens/sign_in_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../widgets/screen_background.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key});

  static const String name = '/forgot-password-verify-otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _forgotpasswordverifyOTPInProgress = false;
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
  }

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
                visible: _forgotpasswordverifyOTPInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: FilledButton(
                  onPressed: _onTapVerifyOtpButton,
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
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.name, (predicate) => false);
  }

  Future<void> _onTapVerifyOtpButton() async {
    String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      showSnackBarMessage(context, "OTP cannot be empty");
      return;
    }

    setState(() => _forgotpasswordverifyOTPInProgress = true);

    final response = await NetworkCaller.getRequest(
      "${Urls.recoverVerifyOtp}/$email/$otp",
    );

    setState(() => _forgotpasswordverifyOTPInProgress = false);

    if (response.isSuccess) {
      Navigator.pushNamed(
        context,
        ResetPasswordScreen.name,
        arguments: {"email": email, "otp": otp},
      );
    } else {
      showSnackBarMessage(
          context, response.errorMessage ?? "Invalid OTP. Try again!");
    }
  }
}
