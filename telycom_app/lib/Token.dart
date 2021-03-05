import 'dart:convert';

class Token {
  final int userId;
  final int id;
  final String title;
  final String body;

  Token({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}