import 'Token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthCall{
  static const  String dominioTelyApiServer = '192.168.15.38';
  static const  String licencia = ' ';
  static const  String tipoAplicacion = ' ';
  static const  String perfil = ' ';

  static Future<Token> fetchToken(String usuario) async {
    String url = 'https://' + dominioTelyApiServer + '/TelyApiServer/?l=' + licencia + '&ta=' + tipoAplicacion + '&p=' + perfil + '&usuario=' + usuario ;

    final response = await http.get(Uri.parse(url));

    switch(response.statusCode){
      case 200: return Token.fromJson(jsonDecode(response.body));
        break;
      case 202: return Token.fromJson(jsonDecode(response.body));
        break;
      case 203: return Token.fromJson(jsonDecode(response.body));
        break;
      case 451: throw Exception('451: Petición no válida');
        break;
      case 460: throw Exception('460: Licencia no válida');
        break;
      case 461: throw Exception('461: Error de licencia');
        break;
      case 462: throw Exception('462: Nº de peticiones superado');
        break;
      case 464: throw Exception('464: Error interno del Servidor');
        break;
      case 552: throw Exception('552: Error interno del servidor');
        break;
      case 553: throw Exception('553: Error interno del servidor');
        break;
      default: throw Exception('Failed to load token');
    }
  }
}
