import 'dart:convert';

class Token {
  final String statusTelyAPI;
  final String tk;

  Token({
    this.statusTelyAPI,
    this.tk,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      statusTelyAPI: json['statusTelyAPI'],
      tk: json['tk'],
    );
  }
}