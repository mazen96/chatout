// To parse this JSON data, do
//
//     final conversation = conversationFromJson(jsonString);

import 'dart:convert';
import 'package:chatout/core/models/message.dart';

Conversation conversationFromJson(String str) =>
    Conversation.fromJson(json.decode(str));

String conversationToJson(Conversation data) => json.encode(data.toJson());

class Conversation {
  Conversation({
    this.userIds,
    this.messages,
  });

  List<String> userIds;
  List<Message> messages;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        userIds: List<String>.from(json["userIds"].map((x) => x)),
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userIds": List<dynamic>.from(userIds.map((x) => x)),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
