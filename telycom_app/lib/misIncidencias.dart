import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:telycom_app/DetalleIncidencias.dart';


import "ElementList.dart";
import "Mapa.dart";

void main() => runApp(MisIncidencias());

class MisIncidencias extends StatefulWidget {
  @override
  _MisIncidenciasState createState() => _MisIncidenciasState();
}

class _MisIncidenciasState extends State<MisIncidencias> {

  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.', 'Atacascos', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.', 'Accidentes de coche',28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.', 'Homicidio', 28.008015, -15.377626),
  ];

  Color colorTarjeta;

  double latitudCenter = 28.0713516;
  double longitudCenter = -15.45598;

  MapController _mapController = MapController();

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  static const _markerSize = 80.0;
  List<Marker> _markers;
  List<LatLng> _points;

  @override
  void initState() {
    super.initState();
    _markers = new List<Marker>();
    _points = new List<LatLng>();

    for(var i = 0; i<itemsList.length ; i++) {
      _points.add(LatLng(itemsList[i].latitud, itemsList[i].longitud));
    }
    _markers = _points
        .map(
          (LatLng point) => Marker(
        point: point,
        width: _markerSize,
        height: _markerSize,
        builder: (ctx) =>
            Image(
              image: AssetImage('images/sirena.png'),
            )
      // Icon(
      //   Icons.pin_drop,
      //   color: Colors.red[900],
      // ),
      // new Container(
      //   child: new FlutterLogo(),
      // ),
      //   builder: (_) => Icon(Icons.location_on, size: _markerSize),
      //   anchorPos: AnchorPos.align(AnchorAlign.top),
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
                tooltip: 'Mostrar mapa completo', // cuando lo mantenemos pulsado no saldra este texto
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp()),
                  );
                },
              ),
            ],
          ),


          body: Column(

            children: [

            ExpansionTile(
              title: Text("Incidencias"),
              backgroundColor: Colors.amberAccent[100],
              children:[ Container(
              height: 200,
                child: new Expanded(
                  child: Row(
                    children: [
                      new Expanded(
                        child: ListView.builder(
                          itemCount: itemsList.length,
                          itemBuilder: (context, index) {
                            if(itemsList[index].state == "Atendido"){
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
                                            reference: itemsList[index].reference ,
                                            state: itemsList[index].state,
                                            direction: itemsList[index].direction,
                                            description: itemsList[index].description,
                                          ),
                                        ));
                                  },
                                  title: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: itemsList[index].creation,
                                            style: TextStyle(color: Colors.white)),
                                        TextSpan(
                                            text: " | ",
                                            style:
                                            TextStyle(color: Colors.deepOrange)),
                                        TextSpan(
                                            text: itemsList[index].reference,
                                            style: TextStyle(color: Colors.white)),
                                        TextSpan(
                                            text: " | ",
                                            style:
                                            TextStyle(color: Colors.deepOrange)),
                                        TextSpan(
                                            text: itemsList[index].state,
                                            style: TextStyle(color: Colors.white)),
                                        TextSpan(
                                            text: " | ",
                                            style:
                                            TextStyle(color: Colors.deepOrange)),
                                        TextSpan(
                                            text: itemsList[index].direction,
                                            style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),

                                leading: GestureDetector(
                                  onTap: ()  {
                                  setState(() {
                                    final snackBar = SnackBar(content: Text(latitudCenter.toString() +
                                        " " + longitudCenter.toString()));
                                    Scaffold.of(context).showSnackBar(snackBar
                                    );
                                    var latlng = LatLng(1.0, 1.0);
                                    double zoom = 4.0; //the zoom you want
                                    _mapController.move(latlng,zoom);

                                  });

                                    // LatLng(latitudCenter, longitudCenter);

                                    // setState(() {
                                    //   latitudCenter = 28.0713516;
                                    //   longitudCenter = -15.45598;
                                    //   LatLng(latitudCenter, longitudCenter);
                                    // });

                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueAccent[200],
                                    child: Icon(
                                      Icons.place,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
            ),

            // Divider(
            //   color: Colors.blueAccent,
            //   thickness: 3,
            // ),
              Flexible(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    maxZoom: 19,
                    minZoom: 10,
                    center: LatLng(latitudCenter, longitudCenter),
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

                    new MarkerLayerOptions(
                      markers: _markers,
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
          )
      ),
    );
  }
}
