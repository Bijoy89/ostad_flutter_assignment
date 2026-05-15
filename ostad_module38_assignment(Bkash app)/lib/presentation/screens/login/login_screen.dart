
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_strings.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController accountController = TextEditingController();
    final TextEditingController pinController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, size: 20, color: AppColors.primary),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(AppStrings.bangla),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: const AssetImage('assets/bkash.png'),
                    height: 40,
                    color: AppColors.primary,
                  ),
                  Icon(Icons.qr_code_2, size: 40, color: AppColors.primary),
                ],
              ),
              const Text(
                'LOG IN ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const Text(
                'To your bKash Account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Account Number field
              TextField(
                controller: accountController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                decoration: const InputDecoration(
                  labelText: AppStrings.accountNumber,
                  labelStyle: TextStyle(fontSize: 13, color: AppColors.textGrey),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
              const SizedBox(height: 16),

              // PIN field
              TextField(
                controller: pinController,
                readOnly: true,
                obscureText: true,
                obscuringCharacter: '●',
                keyboardType: TextInputType.none,
                style: const TextStyle(
                  fontSize: 17,
                  color: AppColors.textDark,
                  letterSpacing: 4,
                ),
                decoration: InputDecoration(
                  labelText: AppStrings.bkashPin,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: AppStrings.enterPin,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    letterSpacing: 0,
                  ),
                  border: const UnderlineInputBorder(),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 8),
                  suffixIcon: const Icon(
                    Icons.fingerprint,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot PIN
              GestureDetector(
                onTap: () {
                  // TODO: implement PIN reset flow
                },
                child: Text(
                  AppStrings.forgotPin,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),

              const Spacer(),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}