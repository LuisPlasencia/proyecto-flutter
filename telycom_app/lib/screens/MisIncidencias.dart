import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
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
  final String imei;
  MisIncidencias({Key key, @required this.tk, @required this.imei}) : super(key: key);

  @override
  _MisIncidenciasState createState() => _MisIncidenciasState(tk, imei);
}

class _MisIncidenciasState extends State<MisIncidencias> {

  Future<List<Suceso>> futureSuceso;

  Future<Logout> futureLogout;
  String tk;
  String imei;
  _MisIncidenciasState(this.tk, this.imei);
  bool _isRefreshButtonDisabled;
  double valueSize;

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
  MapController _mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;
  List<String> names = [];

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(AppLocalizations.of(context).dialogExitAppTitle),
            content: new Text(AppLocalizations.of(context).dialogExitAppContent),
            actions: <Widget>[
              new GestureDetector(
                key: Key('NO'),
                onTap: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context).dialogExitAppNo),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                key: Key('YES'),
                onTap: () {
                  latLongBloc.dispose();
                  sub.cancel();
                  futureLogout = LogoutCall.fetchLogout(tk);
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
  // List<Marker> _markers = <Marker>[];
  // List<LatLng> _points = <LatLng>[];

  Widget _portraitMode() {
    return Column(
      children: [
        FutureBuilder<List<Suceso>>(
                future: futureSuceso,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data.length == 1){
                      valueSize = 0.10;
                    } else if(snapshot.data.length == 2){
                      valueSize = 0.16;
                    } else {
                      valueSize = 0.25;
                    }
                  }
                  if(snapshot.connectionState != ConnectionState.done){
                    if(names.isNotEmpty){
                      statefulMapController.onReady.then((value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            statefulMapController.removeMarkers(names: names);
                            statefulMapController.markers.clear();
                            statefulMapController.statefulMarkers.clear();
                            names.clear();
                          });
                        });

                      });
                    }
                    return _buildLoadingPortrait();
                  }
                  if(_isRefreshButtonDisabled){
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
                  if(names.length < snapshot.data.length){
                      print("nani?");
                      for(int i = 0; i<snapshot.data.length; i++){
                          addMarker(snapshot.data[i], i);
                      }
                    }

                    return ExpansionTile(
                        childrenPadding: EdgeInsets.only(bottom: 5),
                        title: Text(AppLocalizations
                            .of(context)
                            .incidentsLabel),
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
                                    Text(AppLocalizations.of(context).eventReference,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                        height: 20,
                                        child: VerticalDivider(color: Colors.red)),
                                    Text(AppLocalizations.of(context).description,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  maxLines: 10,),

                              ],
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * valueSize,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            colorTarjeta = Colors.red[400];
                            if(snapshot.data.length == 0){
                              return Text(AppLocalizations.of(context).noEventAssigned);
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
                                                  reference:
                                                  snapshot.data[index].refSuceso,
                                                  state: "Atendido",
                                                  direction: snapshot
                                                      .data[index].description,
                                                  description: snapshot
                                                      .data[index].description,
                                                  latitud:
                                                  snapshot.data[index].latitude,
                                                  longitud:
                                                  snapshot.data[index].longitude,
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
                                                      ? snapshot.data[index].description
                                                      : "Vacío",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,),
                                              ),
                                            ),
                                          ],
                                        )),
                                    leading: GestureDetector(
                                      key: Key("centerInMap" + index.toString()),
                                      onTap: () {
                                        setState(() {
                                          var latlng = LatLng(
                                              snapshot.data[index].latitude,
                                              snapshot.data[index].longitude);
                                          final snackBar = SnackBar(
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60.0),
                                        child: Container(
                                          height: 50,
                                          width: 50,
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
                            }
                          },
                        ),
                      )
                    ]);
              } else if (snapshot.hasError) {
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
                                Text(AppLocalizations.of(context).eventReference,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(color: Colors.red)),
                                Text(AppLocalizations.of(context).eventDescription,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                      ),
                      Text(AppLocalizations.of(context).noEventAssigned,
                      style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),)
                    ]);
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
              new TileLayerOptions(
                // {s} means one of the available subdomains (used sequentially to help with browser parallel requests per domain limitation; subdomain values are specified in options;
                // a, b or c by default, can be omitted), {z} — zoom level, {x} and {y} — tile coordinates.
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(
                markers: statefulMapController.markers,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _landscapeMode() {
       return Row(
         children: [
           // sin expanded se rompe??
           Container(
             // ajustar este valor para ver mas grande el mapa
             width: 300,
             child: new FutureBuilder<List<Suceso>>(
                 future: futureSuceso,
                 builder: (context, snapshot) {
                   if(snapshot.connectionState != ConnectionState.done){
                     return _buildLoadingLandscape();
                   }
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     // Add Your Code here.
                     setState(() {
                       _isRefreshButtonDisabled = false;
                     });
                   });
                   if (snapshot.hasData) {
                     if(statefulMapController.markers.length < snapshot.data.length){
                       for(int i = 0; i<snapshot.data.length; i++){
                         addMarker(snapshot.data[i], i);
                       }
                     }

                     return Column(
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
                                   Text(AppLocalizations.of(context).eventReference,
                                       style: TextStyle(
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold)),
                                   Container(
                                       height: 20,
                                       child: VerticalDivider(color: Colors.red)),
                                   Text(AppLocalizations.of(context).eventDescription,
                                       style: TextStyle(
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold)),
                                 ],
                               )),
                         ),
                         Expanded(
                           child: Container(
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
                                               builder: (context) =>
                                                   DetalleIncidencias(
                                                     creation: snapshot
                                                         .data[index].description,
                                                     reference:
                                                     snapshot.data[index].refSuceso,
                                                     state: "Atendido",
                                                     direction: snapshot
                                                         .data[index].description,
                                                     description: snapshot
                                                         .data[index].description,
                                                     latitud:
                                                     snapshot.data[index].latitude,
                                                     longitud:
                                                     snapshot.data[index].longitude,
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
                                             ],
                                           )),
                                       leading: GestureDetector(
                                         key: Key("centerInMap" + index.toString()),
                                         onTap: () {
                                           setState(() {
                                             var latlng = LatLng(
                                                 snapshot.data[index].latitude,
                                                 snapshot.data[index].longitude);
                                             final snackBar = SnackBar(
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
                                         child: ClipRRect(
                                           borderRadius: BorderRadius.circular(60.0),
                                           child: Container(
                                             height: 50,
                                             width: 50,
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
                       ],
                     );

                // Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Center(child: Text("No esta asignado a ninguna incidencia",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),));
              }
              // By default, show a loading spinner.
              return _buildLoadingLandscape();
            },
          ),
        ),
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

              new TileLayerOptions(
                  // {s} means one of the available subdomains (used sequentially to help with browser parallel requests per domain limitation; subdomain values are specified in options;
                  // a, b or c by default, can be omitted), {z} — zoom level, {x} and {y} — tile coordinates.
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),

              new MarkerLayerOptions(
                markers: statefulMapController.markers,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    developer.log('MisIncidencias', name: 'my.app.category');

    // intialize the controllers
    _mapController = MapController();

    // wait for the controller to be ready before using it
    statefulMapController = StatefulMapController(mapController: _mapController);
    statefulMapController.onReady.then((_) => print("The map controller is ready"));

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method
    /// that mutates the map assets is called
    sub = statefulMapController.changeFeed.listen((change) => setState((){}));

    fetchData();

    posicionActual = _determinePosition();

    reloadMapWithGPSPosition();

    _isRefreshButtonDisabled = true;

    super.initState();
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
              onPressed:
                _isRefreshButtonDisabled ? null : refreshData
              ,
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


  /// adds a new marker with unique identifier
  void addMarker(Suceso data, int index) {
    print("addMarker");
    names.add("some marker" + index.toString());
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
              }

              )
      );
    });
  }

  Widget _buildLoadingPortrait() {
    return ExpansionTile(
        childrenPadding: EdgeInsets.only(bottom: 5),
        title: Text(AppLocalizations
            .of(context)
            .incidentsLabel),
        backgroundColor: Colors.amberAccent[100],
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 15),
              child: SpinKitHourGlass(color: Colors.white))

        ]);
  }

  Widget _buildLoadingLandscape() {
    return Container(
              padding: EdgeInsets.only(bottom: 15),
              child: SpinKitHourGlass(color: Colors.grey[600]));
  }

  void fetchData() {
    futureSuceso = SucesoCall.fetchSuceso(tk,'123456789');
  }

  void refreshData() {
    statefulMapController.onReady.then((_) {

      for (int i = 0; i < statefulMapController.markers.length; i++) {
        print("Posicion " +
            i.toString() +
            " : Latitud: " +
            statefulMapController.markers[i].point.latitude.toString() +
            " Longitud: " +
            statefulMapController.markers[i].point.longitude.toString());
      }

      setState(() {
        _isRefreshButtonDisabled = true;
        statefulMapController.statefulMarkers.clear();
        fetchData();
        names.clear();
        posicionActual = _determinePosition();
        reloadMapWithGPSPosition();
      });
    });
  }

  void reloadMapWithGPSPosition() {
    // esto es un callback, determina nuestra posición
    posicionActual.then((value) => {
      developer.log(value.toString(), name: 'my.app.category'),
      latitudCenter = value.latitude,
      longitudCenter = value.longitude,

      statefulMapController.onReady.then((_) {

        //Center the map on the GPS position
        statefulMapController.mapController.move(LatLng(latitudCenter, longitudCenter), 12.0);

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
                      icon: Icon(Icons.location_on, color: Colors.blue[900],),
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
                              child: Text('GPS',
                                  textScaleFactor: 0.9))),
                    ]);
                  } else {
                    w = markerIcon;
                  }
                  return w;
                }));
      })
    });
  }
}
