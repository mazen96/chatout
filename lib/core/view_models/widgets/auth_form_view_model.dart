import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class AuthFormViewModel extends BaseViewModel {
  final FireAuth _auth;
  AuthFormViewModel({@required FireAuth auth}) : _auth = auth;

  Future<dynamic> signIn({String userEmail, String userPassword}) async {
    String errorMessage;
    setBusy(true);

    try {
      await _auth.signIn(uEmail: userEmail, uPassword: userPassword);
    } catch (error) {
      errorMessage = error.message;
    }
    setBusy(false);
    if (errorMessage != null)
      return errorMessage;
    else
      return true;
  }

  ///////////////////////////////////////////////////////////////////////////

  Future<dynamic> signUp(
      {@required String userName,
      @required String userEmail,
      @required String userPassword}) async {
    var result;
    setBusy(true);

    try {
      result = await _auth.signUp(
          username: userName, uEmail: userEmail, uPassword: userPassword);
    } catch (error) {
      result = error;
    }

    setBusy(false);
    return result;
  }
}
