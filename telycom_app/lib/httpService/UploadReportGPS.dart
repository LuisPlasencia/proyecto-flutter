import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UploadReportGPS {

  ///This example stores information in the documents directory.
  ///You can find the path to the documents directory as follows:
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///Once you know where to store the file, create a reference to the file’s full location
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/GPSdata.txt');
  }

  Future<String> uploadImage(filename, url) async {
    print("Estoy subiendo un TXT al sevidor");
    var request = http.MultipartRequest('POST', Uri.parse(url));
    final path = await _localPath;
    print("Este es el path: " + path.toString());
    print("Este es el nombre del fichero: " + filename);
    request.files.add(await http.MultipartFile.fromPath(filename,path.toString() + '/' + filename));
    var res = await request.send();

    print("Esto es el status code de la subida de fichero: " + res.statusCode.toString());

    return res.reasonPhrase;


  }

}