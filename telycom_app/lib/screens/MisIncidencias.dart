import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telycom_app/app/AppMediator.dart';
import 'package:telycom_app/app/MisIncidenciasState.dart';
import 'package:telycom_app/httpService/Album.dart';
import 'package:telycom_app/httpService/Logout.dart';
import 'package:telycom_app/httpService/LogoutCall.dart';
import 'package:telycom_app/httpService/Suceso.dart';
import 'package:telycom_app/httpService/SucesoCall.dart';
import 'dart:developer' as developer;

import '../ElementList.dart';

import 'package:telycom_app/lat_long_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:map_controller/map_controller.dart';

import 'DetalleIncidencias.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class MyAppMisIncidencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MisIncidencias',
      home: MisIncidencias(imei: '', tk: '',),
    );
  }
}

class MisIncidencias extends StatefulWidget  {
  // Para recuperar el Token
  final String tk;
  final String imei;

  MisIncidencias({Key key, @required this.tk, @required this.imei})
      : super(key: key);

  @override
  _MisIncidenciasState createState() => _MisIncidenciasState(tk, imei);
}

class _MisIncidenciasState extends State<MisIncidencias>{

  Future<List<Suceso>> futureSuceso;

  Future<Logout> futureLogout;
  String tk;
  String imei;

  _MisIncidenciasState(this.tk, this.imei);

  bool _isRefreshButtonDisabled;
  double valueSize;

  Future<List<Album>> futureAlbum;

  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido',
        'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.',
        'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido',
        'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido',
        'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.',
        'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido',
        'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido',
        'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.',
        'Accidentes de coche', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido',
        'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
  ];

  Color colorTarjeta;
  Future<Position> posicionActual;
  Position posicionado;
  double latitudCenter = 28.1364; //28.0713516;
  double longitudCenter = 120.29; // -15.45598;
  MapController _mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  List<String> statefulMarkerNames = [];
  AppMediator mediator;
  MisIncidenciasState  state;
  bool errorTimeout;
  bool errorSolved;

  /// Trigger para llamar a la funcion de recuperación de GPS data
  Timer timer;
  String GPSdata;
  double distanceInMeters;


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title:  Text(AppLocalizations.of(context).dialogExitAppTitle),
        content:
         Text(AppLocalizations.of(context).dialogExitAppContent),
        actions: <Widget>[
           GestureDetector(
            key: Key('NO'),
            onTap: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).dialogExitAppNo),
          ),
          SizedBox(height: 16),
           GestureDetector(
            key: Key('YES'),
            onTap: () {
              latLongBloc.dispose();
              sub.cancel();
              timer?.cancel();

              state.statefulMarkers = null;
              state.running = false;
              state.errorTimeout = false;
              state.errorSolved = true;
              mediator.setMisIncidenciasState(state);

              // futureLogout = LogoutCall.fetchLogout(tk);
              Navigator.of(context).pop(true);
            },
            child: Text(AppLocalizations.of(context).dialogExitAppYes),
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
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static const _markerSize = 80.0;

  // List<Marker> _markers = <Marker>[];
  // List<LatLng> _points = <LatLng>[];

  Widget _portraitMode() {
    developer.log('MisIncidencias', name: 'my.app.category');
    return Column(
      children: [
        FutureBuilder<List<Suceso>>(
            future: futureSuceso,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 1) {
                  valueSize = 0.10;
                } else if (snapshot.data.length == 2) {
                  valueSize = 0.16;
                } else {
                  valueSize = 0.25;
                }
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildLoadingPortrait();
              }

              // En este condicional se entra si hemos pulsado el botón de refrescar
              // Si el numero de incidencias es menor en esta llamada, recarga la pantalla para que se actualice la vista y se eliminen correctamente los marcadores.
              // Aparte de eso, reseteo la lista de nombre de marcadores para que se vuelvan a crear con los posibles cambios que haya habido.
              if (_isRefreshButtonDisabled) {
                if (snapshot.hasData) {
                  if(errorTimeout){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      errorTimeout = false;
                      errorSolved = true;
                      state.errorTimeout = errorTimeout;
                      mediator.setMisIncidenciasState(state);
                      print("push1");
                    });
                  } else if (snapshot.data.length < statefulMarkerNames.length) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print("push2");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    });
                  }

                  statefulMarkerNames.clear();
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Add Your Code here.
                  setState(() {
                    // statefulMapController.removeMarkers(names: names);
                    _isRefreshButtonDisabled = false;
                  });
                });
              }
              // print("FutureBuilder");
              if (snapshot.hasData) {
                // Creo tantos marcadores como incidencias registradas.
                if (statefulMarkerNames.length < snapshot.data.length) {
                  print("nani?");
                  state.numberOfMarkers  = 0;
                  for (int i = 0; i < snapshot.data.length; i++) {
                    addMarker(snapshot.data[i], i);
                    state.numberOfMarkers ++;
                  }
                  state.statefulMarkers = statefulMapController.statefulMarkers;
                  mediator.setMisIncidenciasState(state);
                }

                return ExpansionTile(
                    childrenPadding: EdgeInsets.only(bottom: 5),
                    title: Text(AppLocalizations.of(context).incidentsLabel),
                    backgroundColor: Colors.amberAccent[100],
                    children: [
                      Card(
                        child: Container(
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context).messageType,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(color: Colors.red)),
                                Text(AppLocalizations.of(context).eventId,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(color: Colors.red)),
                                Text(
                                    AppLocalizations.of(context).eventReference,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(color: Colors.red)),
                                Text(
                                  AppLocalizations.of(context).description,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 10,
                                ),
                              ],
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * valueSize,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            colorTarjeta = Colors.red[400];
                            if (snapshot.data.length == 0) {
                              return Text(
                                  AppLocalizations.of(context).noEventAssigned);
                            } else {
                              return Card(
                                child: Container(
                                  color: colorTarjeta,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleIncidencias(
                                              creation: snapshot
                                                  .data[index].description,
                                              reference: snapshot
                                                  .data[index].refSuceso,
                                              state: "Atendido",
                                              direction: snapshot
                                                  .data[index].description,
                                              description: snapshot
                                                  .data[index].description,
                                              latitud:
                                                  snapshot.data[index].latitude,
                                              longitud: snapshot
                                                  .data[index].longitude,
                                            ),
                                          ));
                                    },
                                    title: Container(
                                        child: Row(
                                      children: [
                                        Text(snapshot.data[index].tipo,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                            height: 30,
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 1.5,
                                            )),
                                        Text(snapshot.data[index].idSuceso,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                            height: 30,
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 1.5,
                                            )),
                                        Text(snapshot.data[index].refSuceso,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                            height: 30,
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 1.5,
                                            )),
                                        Flexible(
                                          child: Text(
                                            snapshot.data[index].description
                                                    .isNotEmpty
                                                    ? snapshot
                                                    .data[index].description
                                                : "Vacío",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                    leading: GestureDetector(
                                      key: Key("centerInMap" + index.toString()),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue[900], width: 3),
                                          borderRadius: BorderRadius.circular(60.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(60.0),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            color: Colors.blue,
                                            child: BouncingWidget(
                                              duration: Duration(milliseconds: 300),
                                              scaleFactor: 5,
                                              onPressed: () {
                                                setState(() {
                                                var latlng = LatLng(
                                                    snapshot.data[index].latitude,
                                                    snapshot.data[index].longitude);
                                                final snackBar = SnackBar(
                                                  duration: const Duration(milliseconds: 500),
                                                    content: Text("Lat: " +
                                                        latlng.latitude.toString() +
                                                        " | Lon: " +
                                                        latlng.longitude.toString()));

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                double zoom = 12.0; //the zoom you want
                                                statefulMapController.mapController
                                                    .move(latlng, zoom);
                                                  });
                                              },

                                              child: Icon(
                                                Icons.location_pin,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ]);
              } else if (snapshot.hasError) {
                if(state.numberOfMarkers != 0){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print("push3");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    });
                    state.numberOfMarkers = 0;
                    mediator.setMisIncidenciasState(state);
                }

                print("Error:  " + snapshot.error.toString());

                //No incidencias registradas
                if(snapshot.error.toString().substring(0, 15) == "FormatException"){
                  print("Error de no hay incidencias");
                  return ExpansionTile(
                      childrenPadding: EdgeInsets.only(bottom: 5),
                      title: Text(AppLocalizations.of(context).incidentsLabel),
                      backgroundColor: Colors.amberAccent[100],
                      children: [
                        Card(
                          child: Container(
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context).messageType,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(AppLocalizations.of(context).eventId,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(
                                      AppLocalizations.of(context).eventReference,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(
                                      AppLocalizations.of(context)
                                          .eventDescription,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                        ),
                        Text(
                          AppLocalizations.of(context).noEventAssigned,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ]);
                }else{
                  print("Error de timeout");
                  if(!errorTimeout){
                    errorTimeout = true;
                    errorSolved = false;
                    state.errorTimeout = errorTimeout;
                    state.errorSolved = errorSolved;
                    state.statefulMarkers = statefulMapController.statefulMarkers;
                    mediator.setMisIncidenciasState(state);
                  }

                  return ExpansionTile(
                      childrenPadding: EdgeInsets.only(bottom: 5),
                      title: Text(AppLocalizations.of(context).incidentsLabel),
                      backgroundColor: Colors.amberAccent[100],
                      children: [
                        Card(
                          child: Container(
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context).messageType,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(AppLocalizations.of(context).eventId,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(
                                      AppLocalizations.of(context).eventReference,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      height: 20,
                                      child: VerticalDivider(color: Colors.red)),
                                  Text(
                                      AppLocalizations.of(context)
                                          .eventDescription,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                        ),
                        Text(
                          AppLocalizations.of(context).sBTimeoutText,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ]);
                }

              }
              // By default, show a loading spinner.
              return _buildLoadingPortrait();
            }),
        Flexible(
          child: FlutterMap(
            mapController: statefulMapController.mapController,
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

              // statefulMapController.tileLayer,
               TileLayerOptions(
                  // {s} means one of the available subdomains (used sequentially to help with browser parallel requests per domain limitation; subdomain values are specified in options;
                  // a, b or c by default, can be omitted), {z} — zoom level, {x} and {y} — tile coordinates.
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),

              MarkerLayerOptions(
                markers: statefulMapController.markers,
              ),
            ],
          ),
        ),
        //   Positioned(
        //       top: 15.0,
        //       right: 15.0,
        //       child: TileLayersBar(controller: statefulMapController))
      ],
    );
  }

  // Widget _landscapeMode() {
  //   developer.log('MisIncidencias', name: 'my.app.category');
  //   return Row(
  //     children: [
  //       // sin expanded se rompe??
  //       Container(
  //         // ajustar este valor para ver mas grande el mapa
  //         width: 300,
  //         child:
  //          FutureBuilder<List<Suceso>>(
  //           future: futureSuceso,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState != ConnectionState.done) {
  //               return _buildLoadingLandscape();
  //             }
  //             // En este condicional se entra si hemos pulsado el botón de refrescar
  //             // Si el numero de incidencias es menor en esta llamada, recarga la pantalla para que se actualice la vista y se eliminen correctamente los marcadores.
  //             // Aparte de eso, reseteo la lista de nombre de marcadores para que se vuelvan a crear con los posibles cambios que haya habido.
  //             if (_isRefreshButtonDisabled) {
  //               if (snapshot.hasData) {
  //                 if(errorTimeout){
  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     errorTimeout = false;
  //                     state.errorTimeout = errorTimeout;
  //                     mediator.setMisIncidenciasState(state);
  //                     print("push4");
  //                     Navigator.pushReplacement(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (BuildContext context) => super.widget));
  //                   });
  //                 } else if(snapshot.data.length < statefulMarkerNames.length) {
  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     print("push5");
  //                     Navigator.pushReplacement(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (BuildContext context) => super.widget));
  //                   });
  //                 }
  //                 statefulMarkerNames.clear();
  //               }
  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 // Add Your Code here.
  //                 setState(() {
  //                   // statefulMapController.removeMarkers(names: names);
  //                   _isRefreshButtonDisabled = false;
  //                 });
  //               });
  //             }
  //             // print("FutureBuilder");
  //             if (snapshot.hasData) {
  //               // Creo tantos marcadores como incidencias registradas.
  //               if (statefulMarkerNames.length < snapshot.data.length) {
  //                 print("nani?");
  //                 for (int i = 0; i < snapshot.data.length; i++) {
  //                   addMarker(snapshot.data[i], i);
  //                 }
  //                 state.statefulMarkers = statefulMapController.statefulMarkers;
  //                 mediator.setMisIncidenciasState(state);
  //               }
  //
  //               return Column(
  //                 children: [
  //                   Card(
  //                     child: Container(
  //                         color: Colors.blue,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(AppLocalizations.of(context).messageType,
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold)),
  //                             Container(
  //                                 height: 20,
  //                                 child: VerticalDivider(color: Colors.red)),
  //                             Text(AppLocalizations.of(context).eventId,
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold)),
  //                             Container(
  //                                 height: 20,
  //                                 child: VerticalDivider(color: Colors.red)),
  //                             Text(AppLocalizations.of(context).eventReference,
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold)),
  //                             Container(
  //                                 height: 20,
  //                                 child: VerticalDivider(color: Colors.red)),
  //                             Text(
  //                                 AppLocalizations.of(context).eventDescription,
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold)),
  //                           ],
  //                         )),
  //                   ),
  //                   Expanded(
  //                     child: Container(
  //                       child: ListView.builder(
  //                         itemCount: snapshot.data.length,
  //                         itemBuilder: (context, index) {
  //                           // if (itemsList[index].state == "Atendido") {
  //                           //   colorTarjeta = Colors.green[400];
  //                           // } else {
  //                           colorTarjeta = Colors.red[400];
  //                           // }
  //                           return Card(
  //                             child: Container(
  //                               color: colorTarjeta,
  //                               child: ListTile(
  //                                 onTap: () {
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             DetalleIncidencias(
  //                                           creation: snapshot
  //                                               .data[index].description,
  //                                           reference:
  //                                               snapshot.data[index].refSuceso,
  //                                           state: "Atendido",
  //                                           direction: snapshot
  //                                               .data[index].description,
  //                                           description: snapshot
  //                                               .data[index].description,
  //                                           latitud:
  //                                               snapshot.data[index].latitude,
  //                                           longitud:
  //                                               snapshot.data[index].longitude,
  //                                         ),
  //                                       ));
  //                                 },
  //                                 title: Container(
  //                                     child: Row(
  //                                   children: [
  //                                     Text(snapshot.data[index].tipo,
  //                                         style: TextStyle(
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.bold)),
  //                                     Container(
  //                                         height: 30,
  //                                         child: VerticalDivider(
  //                                           color: Colors.black,
  //                                           thickness: 1.5,
  //                                         )),
  //                                     Text(snapshot.data[index].idSuceso,
  //                                         style: TextStyle(
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.bold)),
  //                                     Container(
  //                                         height: 30,
  //                                         child: VerticalDivider(
  //                                           color: Colors.black,
  //                                           thickness: 1.5,
  //                                         )),
  //                                     Text(snapshot.data[index].refSuceso,
  //                                         style: TextStyle(
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.bold)),
  //                                   ],
  //                                 )),
  //                                 leading: GestureDetector(
  //                                   key: Key("centerInMap" + index.toString()),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(color: Colors.blue[900], width: 3),
  //                                       borderRadius: BorderRadius.circular(60.0),
  //                                     ),
  //                                     child: ClipRRect(
  //                                       borderRadius: BorderRadius.circular(60.0),
  //                                       child: Container(
  //                                         height: 50,
  //                                         width: 50,
  //                                         color: Colors.blue,
  //                                         child: BouncingWidget(
  //                                           duration: Duration(milliseconds: 300),
  //                                           scaleFactor: 5,
  //                                           onPressed: () {
  //                                             setState(() {
  //                                               var latlng = LatLng(
  //                                                   snapshot.data[index].latitude,
  //                                                   snapshot.data[index].longitude);
  //                                               final snackBar = SnackBar(
  //                                                   duration: const Duration(milliseconds: 500),
  //                                                   content: Text("Lat: " +
  //                                                       latlng.latitude.toString() +
  //                                                       " | Lon: " +
  //                                                       latlng.longitude.toString()));
  //
  //                                               ScaffoldMessenger.of(context)
  //                                                   .showSnackBar(snackBar);
  //                                               double zoom = 12.0; //the zoom you want
  //                                               statefulMapController.mapController
  //                                                   .move(latlng, zoom);
  //                                             });
  //                                           },
  //
  //                                           child: Icon(
  //                                             Icons.location_pin,
  //                                             color: Colors.black,
  //                                             size: 30.0,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //
  //               // Text(snapshot.data.title);
  //             } else if (snapshot.hasError) {
  //               print("Error:  " + snapshot.error.toString());
  //
  //               //No incidencias registradas
  //               if(snapshot.error.toString().substring(0, 15) == "FormatException"){
  //                 return Center(
  //                     child: Text(
  //                       AppLocalizations.of(context).noEventAssigned,
  //                       style:
  //                       TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  //                     ));
  //               }else{
  //                 if(!errorTimeout){
  //                   errorTimeout = true;
  //                   state.errorTimeout = errorTimeout;
  //                   state.statefulMarkers = statefulMapController.statefulMarkers;
  //                   mediator.setMisIncidenciasState(state);
  //
  //
  //                 }
  //                 return Center(
  //                     child: Text(
  //                         AppLocalizations.of(context).sBTimeoutText,
  //                       style:
  //                       TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  //                     ));
  //               }
  //
  //             }
  //             // By default, show a loading spinner.
  //             return _buildLoadingLandscape();
  //           },
  //         ),
  //       ),
  //       Flexible(
  //         child: FlutterMap(
  //           mapController: statefulMapController.mapController,
  //           options: MapOptions(
  //             maxZoom: 19,
  //             minZoom: 10,
  //             // center: LatLng(latLog.latitude, latLog.longitude),
  //             center: LatLng(latitudCenter, longitudCenter),
  //             zoom: 12.0,
  //           ),
  //           layers: [
  //             // TileLayerOptions(
  //             //   urlTemplate:
  //             //   'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
  //             //   subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
  //             //   tileProvider: CachedNetworkTileProvider(),
  //             // ),
  //
  //              TileLayerOptions(
  //                 // {s} means one of the available subdomains (used sequentially to help with browser parallel requests per domain limitation; subdomain values are specified in options;
  //                 // a, b or c by default, can be omitted), {z} — zoom level, {x} and {y} — tile coordinates.
  //                 urlTemplate:
  //                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
  //                 subdomains: ['a', 'b', 'c']),
  //
  //              MarkerLayerOptions(
  //               markers: statefulMapController.markers,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  void dispose() {
    sub.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    developer.log('MisIncidencias', name: 'my.app.category');
    print("INITSTATE");
    mediator = AppMediator.getInstance();
    state = mediator.getMisIncidenciasState();


    _mapController = state.mapController;
    // statefulMapController = state.statefulMapController;

    errorTimeout = state.errorTimeout;
    errorSolved = state.errorSolved;

    // intialize the controllers
    _mapController = MapController();
    // _mapController = state.mapController;


    // wait for the controller to be ready before using it
    statefulMapController = StatefulMapController(mapController: MapController()) ;;


    statefulMapController.onReady
        .then((_) {
          print("The map controller is ready");
    });

    if(state.statefulMarkers != null){
      statefulMapController.statefulMarkers.addAll(state.statefulMarkers);
    }
    state.statefulMapController = statefulMapController;
    mediator.setMisIncidenciasState(state);

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method
    /// that mutates the map assets is called
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));


    fetchData();

    posicionActual = _determinePosition();

    reloadMapWithGPSPosition();

    _isRefreshButtonDisabled = true;

    checkInternetConnection();

    // GPStrigger();

  }

  void getGPSbyDistance() {

    double tmpLatitudCenter;
    double tmpLongitudCenter;
    for (double i = 0; i<1000; i = i + 0.001) {
      tmpLatitudCenter = latitudCenter - i;
      tmpLongitudCenter = longitudCenter - i;


      posicionActual.then((value) =>
      {
        developer.log(value.toString(), name: 'my.app.category'),
        latitudCenter = value.latitude,
        longitudCenter = value.longitude,
      });

      distanceInMeters =
      Geolocator.distanceBetween(latitudCenter, longitudCenter,
          tmpLatitudCenter, tmpLongitudCenter);

      print("La distancia es: $distanceInMeters");
    }
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
              icon: const Icon(Icons.refresh),
              tooltip: AppLocalizations.of(context).refreshButtonMessage,
              // cuando lo mantenemos pulsado no saldra este texto
              onPressed: _isRefreshButtonDisabled ? null : refreshData,
            ),
          ],
        ),
        body:  _portraitMode()



      ),
    );
  }

  /// adds a new marker with unique identifier
  void addMarker(Suceso data, int index) {
    print("addMarker");
    statefulMarkerNames.add("some marker" + index.toString());
    statefulMapController.onReady.then((_) {
      // print("marcador" + index.toString());
      statefulMapController.addStatefulMarker(
          name: "some marker" + index.toString(),
          statefulMarker: StatefulMarker(
              height: _markerSize,
              width: _markerSize,
              state: <String, dynamic>{"showText": false},
              point: LatLng(data.latitude, data.longitude),
              builder: (BuildContext context, Map<String, dynamic> state) {
                Widget w;
                final markerIcon = IconButton(
                    icon: Image(
                      image: AssetImage('images/sirena.png'),
                    ),
                    onPressed: () => statefulMapController.mutateMarker(
                        name: "some marker" + index.toString(),
                        property: "showText",
                        value: !(state["showText"] as bool)));
                if (state["showText"] == true) {
                  w = Column(children: <Widget>[
                    markerIcon,
                    Container(
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(data.refSuceso, textScaleFactor: 0.9))),
                  ]);
                } else {
                  w = markerIcon;
                }
                return w;
              }));
    });
  }

  void updateMarker(Suceso data, int index) {
    // TODO: update en vez de create en el refresh
    statefulMapController.statefulMarkers
        .update("some marker" + index.toString(), (value) {
      return StatefulMarker(
          height: _markerSize,
          width: _markerSize,
          state: <String, dynamic>{"showText": false},
          point: LatLng(data.latitude, data.longitude),
          builder: (BuildContext context, Map<String, dynamic> state) {
            Widget w;
            final markerIcon = IconButton(
                icon: Image(
                  image: AssetImage('images/sirena.png'),
                ),
                onPressed: () => statefulMapController.mutateMarker(
                    name: "some marker" + index.toString(),
                    property: "showText",
                    value: !(state["showText"] as bool)));
            if (state["showText"] == true) {
              w = Column(children: <Widget>[
                markerIcon,
                Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(data.refSuceso, textScaleFactor: 0.9))),
              ]);
            } else {
              w = markerIcon;
            }
            return w;
          });
    });
  }

  /// Muestra carga del Future en modo portrait
  Widget _buildLoadingPortrait() {
    print("Loading");
    return ExpansionTile(
        childrenPadding: EdgeInsets.only(bottom: 5),
        title: Text(AppLocalizations.of(context).incidentsLabel),
        backgroundColor: Colors.amberAccent[100],
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 15),
              child: SpinKitHourGlass(color: Colors.white))
        ]);
  }

  /// Muestra carga del Future en modo landscape
  Widget _buildLoadingLandscape() {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        child: SpinKitHourGlass(color: Colors.grey[600]));
  }

  /// Llamada al servicio de incidencias
  void fetchData() {
    print("fetchdata");
    futureSuceso = SucesoCall.fetchSuceso(tk, '987654321').timeout(Duration(seconds: 20));
  }

  /// Vuelve a llamar al servicio mientras bloquea el botón de refresh. Borra los marcadores activos ya que se volverán a crear con los cambios que haya habido.
  void refreshData() {

    checkInternetConnection();

    statefulMapController.onReady.then((value) {
      state.statefulMarkers =  statefulMapController.statefulMarkers;
      mediator.setMisIncidenciasState(state);
      setState(() {
        statefulMapController.statefulMarkers.clear();
        _isRefreshButtonDisabled = true;
        fetchData();
        posicionActual = _determinePosition();
        reloadMapWithGPSPosition();
        print("UWU " + statefulMapController.statefulMarkers.length.toString());

        state.statefulMapController = statefulMapController;
        state.mapController = _mapController;
        mediator.setMisIncidenciasState(state);
      });
    });
  }

  ///Espera a los valores del GPS, centra el mapa y actualiza el marcador de GPS
  void reloadMapWithGPSPosition() {
    // esto es un callback, determina nuestra posición
    posicionActual.then((value) => {
      developer.log(value.toString(), name: 'my.app.category'),
      latitudCenter = value.latitude,
      longitudCenter = value.longitude,
      statefulMapController.onReady.then((_) {
        //Center the map on the GPS position
        statefulMapController.mapController
            .move(LatLng(latitudCenter, longitudCenter), 12.0);

        //Create marker with GPS position
        statefulMapController.addStatefulMarker(
            name: "markerGPS",
            statefulMarker: StatefulMarker(
                height: _markerSize,
                width: _markerSize,
                state: <String, dynamic>{"showText": false},
                point: LatLng(latitudCenter, longitudCenter),
                builder:
                    (BuildContext context, Map<String, dynamic> state) {
                  Widget w;
                  final markerIcon = IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.blue[900],
                      ),
                      onPressed: () => statefulMapController.mutateMarker(
                          name: "markerGPS",
                          property: "showText",
                          value: !(state["showText"] as bool)));
                  if (state["showText"] == true) {
                    w = Column(children: <Widget>[
                      markerIcon,
                      Container(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('GPS', textScaleFactor: 0.9))),
                    ]);
                  } else {
                    w = markerIcon;
                  }
                  return w;
                }));
      })
    });
  }

  /// Compruebo si existe conexión hacia el exterior.
  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  ///This example stores information in the documents directory.
  ///You can find the path to the documents directory as follows:
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("El directory es:" + directory.path.toString());
    return directory.path;
  }

  ///Once you know where to store the file, create a reference to the file’s full location
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/GPSdata.txt');

  }

  ///Now that you have a File to work with, use it to read and write data.
  Future<File> writeGPSdata() async {
    print("Se esta escribiendo en un TXT");
    final file = await _localFile;

    return file.writeAsString(GPSdata);
  }

  ///Reading data from a file :+)
  Future<String> readGPSdata() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "";
    }
  }

  /// Nos devuelve el imei, el tiempo en milis y la posicion.
  void getGPSdata() {
    if(GPSdata == null){
      GPSdata = "123456789\r\n" + DateTime.now().millisecondsSinceEpoch.toString() + ";" + latitudCenter.toString() +
          ";" + longitudCenter.toString() + "\r\n";
    }

    GPSdata = GPSdata + DateTime.now().millisecondsSinceEpoch.toString() + ";" + latitudCenter.toString() +
        ";" + longitudCenter.toString() + "\r\n";
  }

  /// Llama a la lectura, escritura cada "x" tiempo
  // void GPStrigger() {
  //
  //   timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getGPSbyDistance());
  //
  //   // si la distancia es mayor de 200 escribo
  //   if(distanceInMeters > 200){
  //     readGPSdata();
  //     writeGPSdata();
  //     getGPSdata();
  //
  //   } else {
  //     timer = Timer.periodic(Duration(seconds: 5), (Timer t) => readGPSdata());
  //     timer = Timer.periodic(Duration(seconds: 5), (Timer t) => writeGPSdata());
  //     timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getGPSdata());
  //   }
  // }
}
