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
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      //return Future.error(errorMessage);
      throw Exception(errorMessage);
    }

    return user.uid;
  }
}
