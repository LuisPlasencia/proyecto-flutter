import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Suceso.dart';

/**
 * Clase para recuperar los sucesos
 */
class SucesoCall{

  static const String dominioTelyApiServer = '192.168.15.38';
  // static const String imei = '987654321';

  static Future<List<Suceso>> fetchSuceso(String token, String imei) async {
    String url = "http://$dominioTelyApiServer/TelyGIS/AndroidServlet?tk=$token&q=getsucesos&imei=$imei";

    // Lista de tamaño expandible
    List<Suceso> listsucesos = [];

    var tipo;
    var idSucesoArray;
    var refSucesoArray;
    var latitudeArray;
    var longitudeArray;
    List<String> descriptionArray;

    final response = await http.get(Uri.parse(url));

    // Array de String.
    var datos = response.body.split('\$');
    tipo = datos[0];
    idSucesoArray = datos[1].split(';'); //[1702,1703,1704]
    refSucesoArray = datos[2].split(';');
    descriptionArray = datos[3].split(';');
    latitudeArray = datos[4].split(';');
    longitudeArray = datos[5].split(';');


    for(int i = 0; i<idSucesoArray.length-1; i++){
      Suceso suceso = new Suceso(tipo, idSucesoArray[i+1], refSucesoArray[i+1], descriptionArray[i+1],
          double.parse(latitudeArray[i+1]), double.parse(longitudeArray[i+1]));
      listsucesos.add(suceso);
    }

    switch (response.statusCode) {
      case 200:
        return listsucesos;
        break;
      case 202:
        return listsucesos;
        break;
      case 203:
        return listsucesos;
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