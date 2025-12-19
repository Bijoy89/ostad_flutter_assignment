import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordEmailProvider extends ChangeNotifier {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future<void> verifyEmail(String email) async {
    if (email.isEmpty) {
      throw Exception("Email cannot be empty");
    }
    if (!EmailValidator.validate(email)) {
      throw Exception("Enter a valid email");
    }

    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest("${Urls.recoverVerifyEmail}/$email");

    _inProgress = false;
    notifyListeners();

    if (!response.isSuccess) {
      throw Exception(response.errorMessage ?? "No user found. Try again!");
    }
  }
}
