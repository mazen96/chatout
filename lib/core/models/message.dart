import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.text,
  });

  String id;
  String senderId;
  String receiverId;
  String text;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "text": text,
      };
}
