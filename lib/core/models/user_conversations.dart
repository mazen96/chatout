import 'dart:convert';

UserConversation userConversationFromJson(String str) =>
    UserConversation.fromJson(json.decode(str));
String userConversationToJson(UserConversation data) =>
    json.encode(data.toJson());

class UserConversation {
  String id;
  String username;
  String email;

  UserConversation({this.id, this.username, this.email});

  factory UserConversation.fromJson(Map<String, dynamic> json) =>
      UserConversation(
          id: json["id"], username: json["username"], email: json["email"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "email": email};
}
