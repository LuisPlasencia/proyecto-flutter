import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
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
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [

              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    maxZoom: 19,
                    minZoom: 10,
                    center: LatLng(28.0713516, -15.45598),
                    zoom: 11.0,
                    plugins: [EsriPlugin()],
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                      'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                      tileProvider: CachedNetworkTileProvider(),
                    ),
                    FeatureLayerOptions(
                      url: "https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/USA_Congressional_Districts/FeatureServer/0",
                      geometryType:"polygon",
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                      },
                      render: (dynamic attributes){
                        // You can render by attribute
                        return PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 2
                        );
                      },

                    ),
                    FeatureLayerOptions(
                      url: "https://services8.arcgis.com/1p2fLWyjYVpl96Ty/arcgis/rest/services/Forest_Service_Recreation_Opportunities/FeatureServer/0",
                      geometryType:"point",
                      render:(dynamic attributes){
                        // You can render by attribute
                        return Marker(
                          width: 30.0,
                          height: 30.0,
                          builder: (ctx) => Icon(Icons.pin_drop),
                        );
                      },
                      onTap: (attributes, LatLng location) {
                        print(attributes);
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}