import 'Incidencia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceCall{
  static const  String dominioTelyApiServer = '192.168.15.38';

  static Future<List<Incidencia>> fetchIncidencias(String tk) async {
    String url = 'http://' + dominioTelyApiServer + '/TelyApiServer/?q=dashboard&tk=' + tk;
    final response = await http.get(Uri.parse(url));

    List<Incidencia> listAlbums;
    switch(response.statusCode){
      case 200:
        listAlbums = postFromJson(response.body);
        return listAlbums;
      break;
      case 202:
        listAlbums = postFromJson(response.body);
        return listAlbums;
      break;
      case 203:
        listAlbums = postFromJson(response.body);
        return listAlbums;
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
