import 'package:chatout/core/models/conversation.dart';
import 'package:chatout/core/models/message.dart';
import 'package:chatout/core/services/firestore_service.dart';
import 'package:chatout/core/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class ConversationViewModel extends BaseViewModel {
  final FirestoreService _firestoreService;
  final String _conversationId;

  ConversationViewModel(
      {@required String conversationID,
      @required FirestoreService firestoreService})
      : _conversationId = conversationID,
        _firestoreService = firestoreService;

  Conversation _currentConversation;

  List<Message> _messages = List<Message>();
  List<Message> get messages => _messages;

  void listenToMessages() {
    // the following function is used to initialize _currentConversation
    // property
    _initializeCurrentConversation();
    /////////////////////////////////////////////////////////////////////
    setBusy(true);
    _firestoreService
        .listenToMessagesRealTime(_conversationId)
        .listen((messagesData) {
      List<Message> updatedMessages = messagesData;
      if (updatedMessages != null && updatedMessages.length > 0) {
        _messages = updatedMessages.reversed.toList();
        notifyListeners();
      }

      setBusy(false);
    });
  }

  void _initializeCurrentConversation() async {
    _currentConversation =
        await _firestoreService.getConversationById(_conversationId);
  }

  void sendMessage(String senderID, String msgText) {
    String receiverID = _currentConversation.userIds
        .firstWhere((possibleID) => possibleID != senderID);
    Message msg =
        Message(senderId: senderID, receiverId: receiverID, text: msgText);
    _firestoreService.sendMessageToCloud(_conversationId, msg);
  }

//  Future getMessages() async {
//    //// note may be bug /////
//    setBusy(true);
//    /////////////////////////
//    try {
//      messages =
//          await _firestoreService.getConversationMessages(_conversationId);
//      notifyListeners(); // v.i.i.i.i.i.i.
//      //// note may be bug /////
//      setBusy(false);
//      /////////////////////////
//    } catch (error) {
//      print(error.toString());
//      return error.toString();
//    }
//  }
}
