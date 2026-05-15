import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier{
  bool _isEnglish =true;
  bool get isEnglish => _isEnglish;

  void toggleLanguage(){
    _isEnglish = !_isEnglish;
    notifyListeners();
  }
  }
