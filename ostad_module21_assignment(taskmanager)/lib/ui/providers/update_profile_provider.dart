import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  bool _updating = false;
  String? _errorMessage;
  XFile? _pickedImage;

  bool get updating => _updating;
  String? get errorMessage => _errorMessage;
  XFile? get pickedImage => _pickedImage;

  void setImage(XFile image) {
    _pickedImage = image;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
  }) async {
    _updating = true;
    notifyListeners();

    Map<String, dynamic> body = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    if (_pickedImage != null) {
      Uint8List bytes = await _pickedImage!.readAsBytes();
      body['photo'] = base64Encode(bytes);
    }

    final response =
    await NetworkCaller.postRequest(Urls.updateProfileUrl, body: body);

    if (response.isSuccess) {
      body['_id'] = AuthController.user!.id;
      await AuthController.updateUserData(UserModel.fromJson(body));
      _errorMessage = null;
      _updating = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      _updating = false;
      notifyListeners();
      return false;
    }
  }
}
