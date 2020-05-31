import 'package:chatout/core/models/friend.dart';
import 'package:chatout/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  Future createUser(User user) async {
    // try-catch block is not present here as error handling
    // will be inside FireBaseAuth service.
    await _usersCollectionReference.document((user.id)).setData(user.toJson());
  }

  Future getUserById(String id) async {
    try {
      var userData = await _usersCollectionReference.document(id).get();
      return User.fromJson(userData.data);
    } catch (error) {
      return error.message;
    }
  }

  Future<User> getUserByEmail(String email) async {
    User tmpUser;
    await _usersCollectionReference
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((querySnapshot) {
      tmpUser = User.fromJson(querySnapshot.documents.first.data);
    }).catchError((error) => error.message);

    return tmpUser;
  }

  Future getUserFriends(String id) async {
    User user;
    try {
      user = await getUserById(id);
    } catch (error) {
      print(error.toString());
      return error;
    }
    return user.friends;
  }

  Future addFriend(
      {@required String currUserId, @required String friendEmail}) async {
    User friend = await getUserByEmail(friendEmail);
    User currentUser = await getUserById(currUserId);
    Friend newFriendData =
        Friend(id: friend.id, email: friend.email, username: friend.username);
    currentUser.friends.add(newFriendData);

    await _usersCollectionReference.document(currUserId).updateData({
      "friends": List<dynamic>.from(currentUser.friends.map((x) => x.toJson()))
    }).catchError((error) {
      print('hiiiiiiiiii :: ${error.toString()}');
      return error.message;
    });
  }

  Future<bool> isUserEmailFound({@required String email}) async {
    int result = 0;
    await _usersCollectionReference
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((querySnapshot) {
      result = querySnapshot.documents.length;
    }).catchError((error) => error.message);

    return result > 0 ? true : false;
  }
}
