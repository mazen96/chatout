import 'dart:convert';
import 'user_conversations.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String username;
  String email;
  List<UserConversation> conversations;

  User({
    this.id,
    this.username,
    this.email,
    this.conversations,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        conversations: List<UserConversation>.from(
            json["conversations"].map((x) => UserConversation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "conversations":
            List<dynamic>.from(conversations.map((x) => x.toJson())),
      };
}
