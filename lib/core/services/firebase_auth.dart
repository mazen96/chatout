import 'package:chatout/core/models/friend.dart';
import 'package:chatout/core/models/user.dart';
import 'package:chatout/core/services/base_auth.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService;
  User _currentUser;

  FireAuth({FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  User get currentUser => _currentUser;

  Future _populateCurrentUser(String userId) async {
    _currentUser = await _firestoreService.getUserById(userId);
  }

  @override
  Future<void> signIn({String uEmail, String uPassword}) async {
    FirebaseUser user;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: uEmail, password: uPassword);
      user = result.user;
    } catch (error) {
      errorMessage = handleAuthException(error);
      throw Exception(errorMessage); // code returns here with exception.
    }

    //TODO:: handle exception handling for the following function call
    await _populateCurrentUser(user.uid);
  } // end of signIn function
  /////////////////////////////////////////////////////

  @override
  Future<String> signUp(
      {String username, String uEmail, String uPassword}) async {
    FirebaseUser fireUser;
    String errorMessage;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: uEmail, password: uPassword);

      fireUser = result.user;
      List<Friend> friendsList = [];
      _currentUser = User(
          id: fireUser.uid,
          username: username,
          email: uEmail,
          friends: friendsList);

      await _firestoreService.createUser(_currentUser);
    } catch (error) {
      errorMessage = handleAuthException(error);
    }

    if (errorMessage != null) {
      //return Exception(errorMessage);
      throw Exception(errorMessage);
    }

    return fireUser.uid;
  }

  /////////////////////////////////////////////////////
  Future<bool> isUserLoggedIn() async {
    //TODO:: error prone handle exceptions
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    // we use __populateCurrentUser function here as in startup view
    // neither signIn nor signUp functions are called if there is a previous
    // user session ,therefore we need to update _currentUser property here
    // as isUserLoggedIn function us called inside the startUpViewModel
    if (currentUser != null) {
      await _populateCurrentUser(currentUser.uid);
    }

    return currentUser != null;
  }

  /////////////////////////////////////////////////////
  @override
  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      return error.message;
    }
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
