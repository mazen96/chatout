import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));
String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.senderId,
    this.receiverId,
    this.text,
  });

  String senderId;
  String receiverId;
  String text;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "receiverId": receiverId,
        "text": text,
      };
}
