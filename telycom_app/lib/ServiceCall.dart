import 'Album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceCall{
  static const String url = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<Album>> fetchAlbum() async {

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List<Album> listAlbums = postFromJson(response.body);
      return listAlbums;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
