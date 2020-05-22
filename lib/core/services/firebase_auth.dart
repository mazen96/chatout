import 'package:chatout/core/services/base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn({String uEmail, String uPassword}) async {
    FirebaseUser user;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: uEmail, password: uPassword);
      user = result.user;
    } catch (error) {
      errorMessage = handleAuthException(error);
    }

    if (errorMessage != null) {
      //return Exception(errorMessage);
      throw Exception(errorMessage);
    }

    return user.uid;
  }
  /////////////////////////////////////////////////////

  @override
  Future<String> signUp({String uEmail, String uPassword}) async {
    FirebaseUser user;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: uEmail, password: uPassword);
      user = result.user;
    } catch (error) {
      errorMessage = handleAuthException(error);
    }

    if (errorMessage != null) {
      //return Exception(errorMessage);
      throw Exception(errorMessage);
    }

    return user.uid;
  }

  /////////////////////////////////////////////////////
  String handleAuthException(dynamic error) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        return "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        return "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        return "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password is not enabled.";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Another account already associated with the provided email address";
        break;
      default:
        return "${error.code}";
    }
  }
}
