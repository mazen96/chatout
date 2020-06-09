import 'dart:async';
import 'package:chatout/core/models/conversation.dart';
import 'package:chatout/core/models/message.dart';
import 'package:chatout/core/models/user_conversations.dart';
import 'package:chatout/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _conversationsCollectionReference =
      Firestore.instance.collection('conversations');

  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>.broadcast();

  Future createUser(User user) async {
    // try-catch block is not present here as error handling
    // will be inside FireBaseAuth service.
    await _usersCollectionReference.document((user.id)).setData(user.toJson());
  }

  Future<User> getUserById(String id) async {
    DocumentSnapshot userData;
    try {
      userData = await _usersCollectionReference.document(id).get();
    } catch (error) {
      print(error.toString());
    }
    return User.fromJson(userData.data);
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
    } catch (error, s) {
      print(error);
      print(s);
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

  Future getConversationById(String conversationId) async {
    try {
      var conversationData = await _conversationsCollectionReference
          .document(conversationId)
          .get();
      return Conversation.fromJson(conversationData.data);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Stream listenToMessagesRealTime(String conversationId) {
    // Register the handler for when messages data changes
    _conversationsCollectionReference
        .document(conversationId)
        .snapshots()
        .listen((conversationSnapShot) {
      if (conversationSnapShot.exists) {
        Conversation conversation =
            Conversation.fromJson(conversationSnapShot.data);

        // Add messages onto the stream controller
        _messageStreamController.add(conversation.messages);
      }
    });

    return _messageStreamController.stream;
  }

  void sendMessageToCloud(String conversationId, Message msg) async {
    Conversation tmpConversation = await getConversationById(conversationId);
    tmpConversation.messages.add(msg);
    _conversationsCollectionReference
        .document(conversationId)
        .setData(tmpConversation.toJson())
        .catchError((error) {
      print(error.toString());
    });
  }
}
