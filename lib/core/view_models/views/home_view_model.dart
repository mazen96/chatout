import 'package:chatout/core/models/user_conversations.dart';
import 'package:chatout/core/models/user.dart';
import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends BaseViewModel {
  final FireAuth _fireAuth;
  final FirestoreService _firestoreService;

  HomeViewModel({@required FireAuth auth, @required FirestoreService firestore})
      : _fireAuth = auth,
        _firestoreService = firestore;

  User get currentUser => _fireAuth.currentUser;

  List<UserConversation> myConversations;

  Future getMyConversations() async {
    setBusy(true);
    String myId = currentUser.id;
    try {
      myConversations = await _firestoreService.getUserConversations(myId);
      notifyListeners(); /////////////////// v.i.i
      setBusy(false);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future signOut() async {
    try {
      await _fireAuth.signOut();
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }
}
