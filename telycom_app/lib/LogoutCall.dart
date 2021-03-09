import 'package:telycom_app/Logout.dart';

import 'Token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoutCall{

  static const String dominioTelyApiServer = '';

  static Future<Logout> fetchLogout(String token) async {
    String url = "http://" + dominioTelyApiServer + "/TelyApiServer/?q=logout&tk=" + token;

    final response = await http.get(Uri.parse(url));

    switch(response.statusCode){
      case 700: return Logout.fromJson(jsonDecode(response.body));
      break;
      case 202: return Logout.fromJson(jsonDecode(response.body));
      break;
      case 203: return Logout.fromJson(jsonDecode(response.body));
      break;
      default: throw Exception('Failed to load token');
    }
  }
}
