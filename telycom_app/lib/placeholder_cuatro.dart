import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telycom_app/ElementList.dart';
import 'package:telycom_app/SucesosList.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import "Mapa.dart";
import 'package:telycom_app/misIncidencias.dart';

import 'package:telycom_app/lat_long_bloc.dart';
import 'placeholder_widget.dart';

class PlaceholderWidgetCuatro extends StatefulWidget {

  final String creation;
  final String reference;
  final String state;
  final String direction;
  final String description;

  // Constructor?
  PlaceholderWidgetCuatro(
      {Key key,
        @required this.state,
        this.creation,
        this.reference,
        this.direction,
        this.description})
      : super(key: key);

  @override
  _PlaceholderWidgetCuatro createState() => new _PlaceholderWidgetCuatro(
      creation, reference, state, direction, description);
}

class _PlaceholderWidgetCuatro extends State<PlaceholderWidgetCuatro> {

  String creation;
  String reference;
  String state;
  String direction;
  String description;

  double latitudCenter = 28.0713516;
  double longitudCenter = -15.45598;

  MapController _mapController = MapController();

  _PlaceholderWidgetCuatro(this.creation, this.reference, this.state, this.direction,
      this.description);

  List<SucesosList> sucesosList = [
    SucesosList(
        'TELYCOM1',
        '',
        '',
        '',
        '',
        '09:56 \n09/02/21',
        'atendido'),
    SucesosList(
        'TELYCOM1',
        '10:30 Tráfico DEFAULT',
        'Las Palmas de Gran Canaria',
        'Atascos y aglomeraciones',
        'Policia Local',
        '11:23 \n09/02/21',
        'creado'),
    SucesosList(
        'TELYCOM2',
        '10:30 Tráfico DEFAULT',
        'Las Palmas de Gran Canaria',
        'Accidente de coche',
        'Policia Local',
        '11:23 \n09/02/21',
        'creado'),
  ];


  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
              // stream: latLongBloc.latLongStream,
              builder: (context, snapshot) {
                LatLng latLog = snapshot.data;
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    maxZoom: 19,
                    minZoom: 10,
                    center: LatLng(28.096288 , -15.412257),
                    zoom: 12.0,
                    plugins: [EsriPlugin()],
                  ),

                  layers: [

                    // TileLayerOptions(
                    //   urlTemplate:
                    //   'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    //   subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    //   tileProvider: CachedNetworkTileProvider(),
                    // ),

                    new TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']
                    ),

                    // FeatureLayerOptions(
                    //   url: "https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/USA_Congressional_Districts/FeatureServer/0",
                    //   geometryType:"polygon",
                    //   onTap: (attributes, LatLng location) {
                    //     print(attributes);
                    //   },
                    //   render: (dynamic attributes){
                    //     // You can render by attribute
                    //     return PolygonOptions(
                    //         borderColor: Colors.blueAccent,
                    //         color: Colors.black12,
                    //         borderStrokeWidth: 2
                    //     );
                    //   },
                    //
                    // ),
                    // FeatureLayerOptions(
                    //   url: "https://services8.arcgis.com/1p2fLWyjYVpl96Ty/arcgis/rest/services/Forest_Service_Recreation_Opportunities/FeatureServer/0",
                    //   geometryType:"point",
                    //   render:(dynamic attributes){
                    //     // You can render by attribute
                    //     return Marker(
                    //       width: 30.0,
                    //       height: 30.0,
                    //       point: new LatLng(28.0713516, -15.455989),
                    //       builder: (ctx) =>
                    //           Icon(Icons.pin_drop),
                    //     );
                    //   },
                    //   onTap: (attributes, LatLng location) {
                    //     print(attributes);
                    //   },
                    // ),

                    FeatureLayerOptions(
                      url: "https://services8.arcgis.com/1p2fLWyjYVpl96Ty/arcgis/rest/services/Forest_Service_Recreation_Opportunities/FeatureServer/0",
                      geometryType:"point",
                      render:(dynamic attributes){
                        // You can render by attribute
                        return Marker(
                          point: LatLng(28.096288 , -15.412257 ),
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
                );
              }
          );
  }
}