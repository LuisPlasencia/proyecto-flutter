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
      case 451: throw Exception('451: Petición no válida');
      break;
      case 460: throw Exception('460: Licencia no válida');
      break;
      case 461: throw Exception('461: Error de licencia');
      break;
      case 462: throw Exception('462: Nº de peticiones superado');
      break;
      case 464: throw Exception('464: La licencia no admite usuarios de terceros');
      break;
      case 552: throw Exception('552: Error de acceso a base de datos');
      break;
      case 553: throw Exception('553: Error de acceso a base de datos');
      break;
      default: throw Exception('Failed to load token');
    }
  }
}
