import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module21_assignment/ui/screens/sign_in_screen.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String name = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _ResetPasswordInProgress = false;
  bool _passwordVisible = false;
  late String email;
  late String otp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receiving email & OTP from previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    email = args["email"]!;
    otp = args["otp"]!;
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
                'Reset Password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Minimum length of password should be more than 8 letters',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration:  InputDecoration(
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_passwordVisible,
                decoration:  InputDecoration(
                    hintText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: _ResetPasswordInProgress ==false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: FilledButton(
                  onPressed: _onTapConfirmButton,
                  child: const Text('Confirm'),
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
      context,
      SignInScreen.name,
          (predicate) => false,
    );
  }

  Future<void> _onTapConfirmButton() async {
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      showSnackBarMessage(context, "All fields are required");
      return;
    }

    if (password.length < 8) {
      showSnackBarMessage(context, "Password must be at least 8 characters");
      return;
    }

    if (password != confirmPassword) {
      showSnackBarMessage(context, "Passwords do not match");
      return;
    }

    setState(() => _ResetPasswordInProgress = true);

    final response = await NetworkCaller.postRequest(
      Urls.recoverResetPassword,
      body: {"email": email, "OTP": otp, "password": password},
    );

    setState(() => _ResetPasswordInProgress = false);

    if (response.isSuccess) {
      showSnackBarMessage(context, "Password reset successful!");
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
            (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage ?? "Failed to reset password");
    }
  }
}
