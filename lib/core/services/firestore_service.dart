import 'package:chatout/core/models/conversation.dart';
import 'package:chatout/core/models/user_conversations.dart';
import 'package:chatout/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _conversationsCollectionReference =
      Firestore.instance.collection('conversations');

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
      print(error.toString());
      return error.toString();
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

  Future getUserConversations(String id) async {
    User user;
    try {
      user = await getUserById(id);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
    return user.conversations;
  }

  Future addConversation(
      {@required String currUserId, @required String friendEmail}) async {
    // get current user data and the friend user data
    User friend = await getUserByEmail(friendEmail);
    User currentUser = await getUserById(currUserId);

    // create new conversation data model and get its generated id
    Conversation newConversation =
        Conversation(userIds: [currUserId, friend.id], messages: []);
    DocumentReference ref =
        await _conversationsCollectionReference.add(newConversation.toJson());
    String conversationId = ref.documentID;

    // update conversations field inside currUser data
    UserConversation myConversationData = UserConversation(
        id: conversationId, email: friend.email, username: friend.username);
    currentUser.conversations.add(myConversationData);

    await _usersCollectionReference.document(currUserId).updateData({
      "conversations":
          List<dynamic>.from(currentUser.conversations.map((x) => x.toJson()))
    });

    // update conversations field inside FriendUser data
    UserConversation friendConversationData = UserConversation(
        id: conversationId,
        email: currentUser.email,
        username: currentUser.username);
    friend.conversations.add(friendConversationData);

    await _usersCollectionReference.document(friend.id).updateData({
      "conversations":
          List<dynamic>.from(friend.conversations.map((x) => x.toJson()))
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
