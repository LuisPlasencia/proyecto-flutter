import 'dart:convert';

class Logout {
  final String statusTelyAPI;

  Logout({
    this.statusTelyAPI,

  });

  factory Logout.fromJson(Map<String, dynamic> json) {
    return Logout(
      statusTelyAPI: json['statusTelyAPI'],
    );
  }
}