import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordVerifyOtpProvider extends ChangeNotifier {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> verifyOtp(String email, String otp) async {
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest("${Urls.recoverVerifyOtp}/$email/$otp");

    _inProgress = false;
    notifyListeners();

    if (!response.isSuccess) {
      throw Exception(response.errorMessage ?? "Invalid OTP. Try again!");
    }
  }
}
