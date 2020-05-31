import 'package:chatout/core/models/friend.dart';
import 'package:chatout/core/models/user.dart';
import 'package:chatout/core/services/firebase_auth.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/cupertino.dart';

class AddFriendViewModel extends BaseViewModel {
  final FireAuth _fireAuth;
  final FirestoreService _firestoreService;
  AddFriendViewModel(
      {@required FireAuth fireAuth,
      @required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        _fireAuth = fireAuth;

  User get currentUser => _fireAuth.currentUser;

  Future addFriend({@required String friendEmail}) async {
    ////////////////////////////////////////
    setBusy(true);
    print('case01');
    bool isUserEmailFound =
        await _firestoreService.isUserEmailFound(email: friendEmail);
    print('case02');
    if (isUserEmailFound == false) {
      print('case1');
      throw (Exception("User Not Found"));
    } else if (friendAlreadyExists(friendEmail)) {
      print('case2');
      throw (Exception("User already found in your friends"));
    } else {
      // email found in users DB and user has no friends with the provided email
      print('case3');
      await _firestoreService.addFriend(
          currUserId: currentUser.id, friendEmail: friendEmail);
    }
    setBusy(false);
  }

  bool friendAlreadyExists(String friendEmail) {
    List<Friend> userFriendsList = currentUser.friends;
    if (userFriendsList.isNotEmpty) {
      int result = userFriendsList.indexWhere((friend) {
        return friend.email == friendEmail;
      });
      return result == -1 ? false : true;
    } else {
      return false;
    }
  }
}
