import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class AuthFormViewModel extends BaseViewModel {
  FireAuth _auth;
  AuthFormViewModel({@required FireAuth auth}) : _auth = auth;

  Future<dynamic> signIn({String userEmail, String userPassword}) async {
    var result;
    setBusy(true);

    try {
      result = await _auth.signIn(uEmail: userEmail, uPassword: userPassword);
    } catch (error) {
      result = error;
    }

    setBusy(false);
    return result;
  }

  ///////////////////////////////////////////////////////////////////////////

  Future<dynamic> signUp({String userEmail, String userPassword}) async {
    var result;
    setBusy(true);

    try {
      result = await _auth.signUp(uEmail: userEmail, uPassword: userPassword);
    } catch (error) {
      result = error;
    }

    setBusy(false);
    return result;
  }
}
