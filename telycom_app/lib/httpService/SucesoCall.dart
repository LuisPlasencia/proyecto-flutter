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

    var idSucesoArray;
    var refSucesoArray;
    var descriptionArray;
    var latitudeArray;
    var longitudeArray;

    final response = await http.get(Uri.parse(url));

    // Array de String.
    var datos = response.body.split('\$');
    tipo = datos[0];
    idSucesoArray = datos[1].split(';'); //[1702,1703,1704]
    refSucesoArray = datos[2].split(';');
    descriptionArray = datos[3].split(';');
    latitudeArray = datos[4].split(';');
    longitudeArray = datos[5].split(';');



    Suceso suceso = new Suceso(tipo, idSucesoArray[3].toString(), "refSuceso", "description"
        , 20, 23);

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