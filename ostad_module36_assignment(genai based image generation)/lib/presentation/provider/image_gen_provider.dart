import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../core/constants/app_strings.dart';
import '../../data/service/image_gen_api_service.dart';
import '../../domain/entities/image_message_entity.dart';

class ImageGenProvider extends ChangeNotifier {
  ImageGenProvider({ImageGenApiService? service})
    : _service = service ?? ImageGenApiService();

  final ImageGenApiService _service;
  final List<ImageMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ImageMessage> get messages => List.unmodifiable(_messages);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> generateImage(String prompt) async {
    if (prompt.trim().isEmpty) return;
    _messages.add(
      ImageMessage(role: 'user', prompt: prompt, time: DateTime.now()),
    );
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _service.generateImage(prompt);
      _messages.add(
        ImageMessage(
          role: 'assistant',
          prompt: prompt,
          imageUrl: result.imageUrl,
          textContent: result.textContent,
          time: DateTime.now(),
        ),
      );
    } on TimeoutException {
      _errorMessage = AppStrings.errorTimeout;
    } on SocketException {
      _errorMessage = AppStrings.errorNoInternet;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
