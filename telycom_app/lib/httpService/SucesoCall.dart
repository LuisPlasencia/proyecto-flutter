import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Suceso.dart';

/**
 * Clase para recuperar los sucesos
 */
class SucesoCall{

  static const String dominioTelyApiServer = '192.168.15.38';
  static const String imei = '987654321';

  static Future<Suceso> fetchSuceso(String token) async {
    String url = "http://$dominioTelyApiServer/TelyGIS/AndroidServlet?tk=$token&q=getsucesos&imei=$imei";
    String tipo;
    String idSuceso;
    String refSuceso;
    String description;
    String latitude;
    String longitude;

    final response = await http.get(Uri.parse(url));

    // Array de String.
    var datos = response.body.split('\$');
    tipo = datos[0];
    idSuceso = datos[1].substring(9);
    refSuceso = datos[2].substring(10);
    description = datos[3].substring(12);
    latitude = datos[4].substring(9);
    longitude = datos[5].substring(10);

    Suceso suceso = new Suceso(tipo, idSuceso, refSuceso, description
        , double.parse(latitude), double.parse(longitude));

      switch (response.statusCode) {
        case 200:
          return suceso;
          break;
        case 202:
          return suceso;
          break;
        case 203:
          return suceso;
          break;
        case 451:
          throw Exception('451: Petición no válida');
          break;
        case 460:
          throw Exception('460: Licencia no válida');
          break;
        case 461:
          throw Exception('461: Error de licencia');
          break;
        case 462:
          throw Exception('462: Nº de peticiones superado');
          break;
        case 464:
          throw Exception('464: La licencia no admite usuarios de terceros');
          break;
        case 552:
          throw Exception('552: Error de acceso a base de datos');
          break;
        case 553:
          throw Exception('553: Error de acceso a base de datos');
          break;
        default:
          throw Exception('Failed to load token');
      }


  }
}