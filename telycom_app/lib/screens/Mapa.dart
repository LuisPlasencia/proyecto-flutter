import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Mapa')),
        body: FlutterMap(
          options: MapOptions(
            maxZoom: 19,
            minZoom: 10,
            center: LatLng(28.0713516, -15.45598),
            zoom: 11.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
              'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            ),

          ],
        ),
      );
  }
}