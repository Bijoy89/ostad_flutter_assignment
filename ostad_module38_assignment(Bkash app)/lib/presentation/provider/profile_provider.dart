import 'package:flutter/material.dart';

import '../../data/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier{
  ProfileModel _profile = ProfileModel(name: 'Jannat Al Naeem', phone: '+8801912474177', avatarInitials: 'JN');

  ProfileModel get profile => _profile;

  bool _oneTapTransaction=false;
  bool _bkashNfc=false;
  bool _touchFaceId=false;

  bool get oneTapTransaction => _oneTapTransaction;
  bool get bkashNfc => _bkashNfc;
  bool get touchFaceId => _touchFaceId;

  void toggleOneTapTransaction(){
    _oneTapTransaction = !_oneTapTransaction;
    notifyListeners();
  }

  void toggleBkashNfc(){
    _bkashNfc = !_bkashNfc;
    notifyListeners();
  }

  void toggleTouchFaceId(){
    _touchFaceId = !_touchFaceId;
    notifyListeners();
  }
  }
