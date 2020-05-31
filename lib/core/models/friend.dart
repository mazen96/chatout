class Friend {
  String id;
  String username;
  String email;

  Friend({this.id, this.username, this.email});

  factory Friend.fromJson(Map<String, dynamic> json) =>
      Friend(id: json["id"], username: json["username"], email: json["email"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "email": email};
}
