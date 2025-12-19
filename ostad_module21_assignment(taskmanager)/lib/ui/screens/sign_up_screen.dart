import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sign_up_provider.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _emailTE = TextEditingController();
  final _firstNameTE = TextEditingController();
  final _lastNameTE = TextEditingController();
  final _mobileTE = TextEditingController();
  final _passwordTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignUpProvider>();

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text('Join With Us',
                    style: Theme.of(context).textTheme.titleLarge),

                _buildField(_emailTE, 'Email',
                    validator: (v) =>
                    EmailValidator.validate(v!) ? null : 'Invalid email'),
                _buildField(_firstNameTE, 'First name'),
                _buildField(_lastNameTE, 'Last name'),
                _buildField(_mobileTE, 'Mobile'),
                _buildPasswordField(),

                const SizedBox(height: 8),

                Visibility(
                  visible: !provider.signUpInProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: _onTapSignUp,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(color: Colors.green),
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
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      validator: validator ??
              (v) => v!.trim().isEmpty ? 'Required field' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordTE,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: (v) =>
      v!.length < 6 ? 'Minimum 6 characters' : null,
    );
  }

  Future<void> _onTapSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SignUpProvider>();

    final success = await provider.signUp(
      email: _emailTE.text.trim(),
      firstName: _firstNameTE.text.trim(),
      lastName: _lastNameTE.text.trim(),
      mobile: _mobileTE.text.trim(),
      password: _passwordTE.text,
    );

    if (success) {
      showSnackBarMessage(context, 'Registration successful!');
      Navigator.pop(context);
    } else {
      showSnackBarMessage(context, provider.errorMessage!);
    }
  }
}
