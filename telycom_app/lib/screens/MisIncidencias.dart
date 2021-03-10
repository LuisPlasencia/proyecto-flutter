import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telycom_app/httpService/Album.dart';
import 'package:telycom_app/httpService/Logout.dart';
import 'package:telycom_app/httpService/LogoutCall.dart';
import 'package:telycom_app/httpService/ServiceCalzl.dart';
import 'dart:developer' as developer;

import '../ElementList.dart';

import 'package:telycom_app/lat_long_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'DetalleIncidencias.dart';
import 'Login.dart';

void main() => runApp(MisIncidencias());

class MyAppMisIncidencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MisIncidencias',
      home: MisIncidencias(),
    );
  }
}

class MisIncidencias extends StatefulWidget {
  // Para recuperar el Token
  final String tk;
  MisIncidencias({Key key, @required this.tk}) : super(key: key);

  @override
  _MisIncidenciasState createState() => _MisIncidenciasState(tk);

}

class _MisIncidenciasState extends State<MisIncidencias> {

  Future<Logout> futureLogout;
  String tk;
  _MisIncidenciasState(this.tk);

  Future<List<Album>> futureAlbum;
  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.', 'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.', 'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.', 'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
  ];

  Color colorTarjeta;
  Future<Position> posicionActual;
  Position posicionado;
  double latitudCenter = 28.1364; //28.0713516;
  double longitudCenter = 120.29; // -15.45598;
  MapController _mapController = MapController();

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(tk),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                key: Key("NO"),
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                key: Key("YES"),
                onTap: () {
                  latLongBloc.dispose();
                  futureLogout = LogoutCall.fetchLogout(tk);
                  Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static const _markerSize = 80.0;
  List<Marker> _markers;
  List<LatLng> _points;

  Widget _portraitMode() {
    return Column(
      children: [
        ExpansionTile(
            childrenPadding: EdgeInsets.only(bottom: 5),
            title: Text("Incidencias"),
            backgroundColor: Colors.amberAccent[100],
            children: [
              FutureBuilder<List<Album>>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          // if (itemsList[index].state == "Atendido") {
                          //   colorTarjeta = Colors.green[400];
                          // } else {
                            colorTarjeta = Colors.red[400];
                          // }
                          return Card(
                            child: Container(
                              color: colorTarjeta,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalleIncidencias(
                                          creation: itemsList[index].creation,
                                          reference: itemsList[index].reference,
                                          state: itemsList[index].state,
                                          direction: itemsList[index].direction,
                                          description: itemsList[index].description,
                                          latitud: itemsList[index].latitud,
                                          longitud: itemsList[index].longitud,
                                        ),
                                      ));
                                },
                                title: RichText(
                                  // le pasamos la posicion para poder testearlo luego!
                                  key: Key("listElement" + index.toString()),
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data[index].title,
                                          style: TextStyle(color: Colors.white)),
                                      TextSpan(
                                          text: " | ",
                                          style: TextStyle(color: Colors.deepOrange)),
                                      TextSpan(
                                          text: "itemsList[index].reference",
                                          style: TextStyle(color: Colors.white)),
                                      TextSpan(
                                          text: " | ",
                                          style: TextStyle(color: Colors.deepOrange)),
                                      TextSpan(
                                          text: "itemsList[index].state",
                                          style: TextStyle(color: Colors.white)),
                                      TextSpan(
                                          text: " | ",
                                          style: TextStyle(color: Colors.deepOrange)),
                                      TextSpan(
                                          text: "itemsList[index].direction",
                                          style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                leading: GestureDetector(
                                  key: Key("centerInMap" + index.toString()),
                                  onTap: () {
                                    setState(() {
                                      var latlng = LatLng(itemsList[index].latitud,
                                          itemsList[index].longitud);
                                      final snackBar = SnackBar(
                                          content: Text(latlng.latitude.toString() +
                                              " " +
                                              latlng.longitude.toString()));

                                      Scaffold.of(context).showSnackBar(snackBar);
                                      double zoom = 12.0; //the zoom you want
                                      _mapController.move(latlng, zoom);
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      height: 70.0,
                                      width: 60.0,
                                      color: Colors.blue,
                                      child: Icon(
                                        Icons.place,
                                        color: Colors.black,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );

                      // Text(snapshot.data.title);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return Container(
                    padding: EdgeInsets.only(bottom:15),
                      child: SpinKitHourGlass(color: Colors.white));
                },
              ),

            ]),
        Flexible(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              maxZoom: 19,
              minZoom: 10,
              // center: LatLng(latLog.latitude, latLog.longitude),
              center: LatLng(latitudCenter, longitudCenter),
              zoom: 12.0,
            ),
            layers: [
              // TileLayerOptions(
              //   urlTemplate:
              //   'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              //   subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
              //   tileProvider: CachedNetworkTileProvider(),
              // ),

              new TileLayerOptions(
                // {s} means one of the available subdomains (used sequentially to help with browser parallel requests per domain limitation; subdomain values are specified in options;
                // a, b or c by default, can be omitted), {z} — zoom level, {x} and {y} — tile coordinates.
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(
                markers: _markers,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _landscapeMode() {
    return OrientationBuilder(
      builder: (context, orientation) {
       return new Row(
         children: [
           // sin expanded se rompe??
           Container(
             // ajustar este valor para ver mas grande el mapa
             width: 300,
             child: new Expanded(
               child: Container(
                 child: ListView.builder(
                   itemCount: itemsList.length,
                   itemBuilder: (context, index) {
                     if (itemsList[index].state == "Atendido") {
                       colorTarjeta = Colors.green[400];
                     } else {
                       colorTarjeta = Colors.red[400];
                     }
                     return Card(
                       child: Container(
                         color: colorTarjeta,
                         child: ListTile(
                           onTap: () {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => DetalleIncidencias(
                                     creation: itemsList[index].creation,
                                     reference: itemsList[index].reference,
                                     state: itemsList[index].state,
                                     direction: itemsList[index].direction,
                                     description: itemsList[index].description,
                                     latitud: itemsList[index].latitud,
                                     longitud: itemsList[index].longitud,
                                   ),
                                 ));
                           },
                           title: RichText(
                             // le pasamos la posicion para poder testearlo luego!
                             key: Key("listElement" + index.toString()),
                             text: TextSpan(
                               children: <TextSpan>[
                                 TextSpan(
                                     text: itemsList[index].creation,
                                     style: TextStyle(color: Colors.white)),
                                 TextSpan(
                                     text: " | ",
                                     style: TextStyle(color: Colors.deepOrange)),
                                 TextSpan(
                                     text: itemsList[index].reference,
                                     style: TextStyle(color: Colors.white)),
                                 TextSpan(
                                     text: " | ",
                                     style: TextStyle(color: Colors.deepOrange)),
                                 TextSpan(
                                     text: itemsList[index].state,
                                     style: TextStyle(color: Colors.white)),
                                 TextSpan(
                                     text: " | ",
                                     style: TextStyle(color: Colors.deepOrange)),
                                 TextSpan(
                                     text: itemsList[index].direction,
                                     style: TextStyle(color: Colors.white)),
                               ],
                             ),
                           ),
                           leading: GestureDetector(
                             key: Key("centerInMap" + index.toString()),
                             onTap: () {
                               setState(() {
                                 var latlng = LatLng(itemsList[index].latitud,
                                     itemsList[index].longitud);
                                 final snackBar = SnackBar(
                                     content: Text(latlng.latitude.toString() +
                                         " " +
                                         latlng.longitude.toString()));
                                 Scaffold.of(context).showSnackBar(snackBar);
                                 double zoom = 12.0; //the zoom you want
                                 _mapController.move(latlng, zoom);
                               });
                             },
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(60.0),
                               child: Container(
                                 margin:
                                 const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                 height: 70.0,
                                 width: 60.0,
                                 color: Colors.blue,
                                 child: Icon(
                                   Icons.place,
                                   color: Colors.black,
                                   size: 30.0,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     );
                   },
                 ),
               ),
             ),
           ),
           Flexible(
             child: FlutterMap(
               mapController: _mapController,
               options: MapOptions(
                 maxZoom: 19,
                 minZoom: 10,
                 // center: LatLng(latLog.latitude, latLog.longitude),
                 center: LatLng(latitudCenter, longitudCenter),
                 zoom: 12.0,
               ),
               layers: [
                 // TileLayerOptions(
                 //   urlTemplate:
                 //   'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                 //   subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                 //   tileProvider: CachedNetworkTileProvider(),
                 // ),

                 new TileLayerOptions(
                     urlTemplate:
                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                     subdomains: ['a', 'b', 'c']),

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
                 new MarkerLayerOptions(
                   markers: _markers,
                 ),

               ],
             ),
           ),
         ],
       );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = ServiceCalzl.fetchAlbum();

    posicionActual = _determinePosition();
    developer.log('log me', name: 'my.app.category');

    // esto es un callback
    posicionActual.then((value) => {
          developer.log(value.toString(), name: 'my.app.category'),
          latitudCenter = value.latitude,
          longitudCenter = value.longitude,
          _mapController.move(LatLng(latitudCenter, longitudCenter), 12.0),
        });

    latLongBloc.updateLatLong(LatLng(latitudCenter, longitudCenter));

    _markers = <Marker>[];
    _points = <LatLng>[];

    for (var i = 0; i < itemsList.length; i++) {
      _points.add(LatLng(itemsList[i].latitud, itemsList[i].longitud));
    }
    _markers = _points
        .map(
          (LatLng point) => Marker(
              point: point,
              width: _markerSize,
              height: _markerSize,
              builder: (ctx) => Image(
                    image: AssetImage('images/sirena.png'),
                  )

              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mis incidencias"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_location),
              tooltip: 'Mostrar mapa completo',
              // cuando lo mantenemos pulsado no saldra este texto
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),

        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _portraitMode();
            } else {
              return _landscapeMode();
            }
          },
        ),

      ),
    );
  }
}
