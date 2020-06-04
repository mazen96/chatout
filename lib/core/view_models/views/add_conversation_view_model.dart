import 'package:chatout/core/models/user_conversations.dart';
import 'package:chatout/core/models/user.dart';
import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class AddConversationViewModel extends BaseViewModel {
  final FireAuth _fireAuth;
  final FirestoreService _firestoreService;
  AddConversationViewModel(
      {@required FireAuth fireAuth,
      @required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        _fireAuth = fireAuth;

  User get currentUser => _fireAuth.currentUser;

  Future<bool> addConversation({@required String friendEmail}) async {
    ////////////////////////////////////////
    setBusy(true);
    bool isUserEmailFound =
        await _firestoreService.isUserEmailFound(email: friendEmail);
    if (isUserEmailFound == false) {
      throw (Exception("User Not Found"));
    } else if (conversationAlreadyExists(friendEmail)) {
      throw (Exception("User already found in your chats"));
    } else {
      // email found in users DB and user has no chats with the provided email
      await _firestoreService.addConversation(
          currUserId: currentUser.id, friendEmail: friendEmail);
    }
    setBusy(false);
    return true;
  }

  bool conversationAlreadyExists(String friendEmail) {
    List<UserConversation> userConversationsList = currentUser.conversations;
    if (userConversationsList.isNotEmpty) {
      int result = userConversationsList.indexWhere((friend) {
        return friend.email == friendEmail;
      });
      return result == -1 ? false : true;
    } else {
      return false;
    }
  }
}
