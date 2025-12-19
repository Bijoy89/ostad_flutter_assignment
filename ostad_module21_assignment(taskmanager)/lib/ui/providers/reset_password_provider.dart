import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ResetPasswordProvider extends ChangeNotifier {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future<void> resetPassword(String email, String otp, String password) async {
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      Urls.recoverResetPassword,
      body: {"email": email, "OTP": otp, "password": password},
    );

    _inProgress = false;
    notifyListeners();

    if (!response.isSuccess) {
      throw Exception(response.errorMessage ?? "Failed to reset password");
    }
  }
}
