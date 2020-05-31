import 'package:chatout/core/constants/app_constants.dart';
import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/services/navigation_service.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class StartUpViewModel extends BaseViewModel {
  final FireAuth _auth;
  final NavigationService _navigationService;
  StartUpViewModel({@required FireAuth auth, @required NavigationService nav})
      : _auth = auth,
        _navigationService = nav;

  Future decideStartUpScreen() async {
    bool userFound = await _auth.isUserLoggedIn();
    await new Future.delayed(Duration(seconds: 2));
    if (userFound) {
      _navigationService.pushReplacementNamed(RoutePaths.Home);
    } else {
      _navigationService.pushReplacementNamed(RoutePaths.SignIn);
    }
  }
}
