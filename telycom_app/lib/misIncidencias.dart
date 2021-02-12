import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


import "ElementList.dart";
import "Mapa.dart";

void main() => runApp(MisIncidencias());

class MisIncidencias extends StatefulWidget {
  @override
  _MisIncidenciasState createState() => _MisIncidenciasState();
}

class _MisIncidenciasState extends State<MisIncidencias> {
  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.', 28.0713516, -15.45598),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.', 28.114198, -15.425447),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.', 28.008015, -15.377626),
  ];

  Color colorTarjeta;

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

  @override
  void initState() {
    super.initState();
  }

  Widget _buildChild() {
    if (true) {
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
                icon: const Icon(Icons.add_location),
                tooltip: 'Show Snackbar',
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
            new Expanded(
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
                                      builder: (context) => MyApp()),
                                );
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
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('images/bear.png'),
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

            Divider(
              color: Colors.blueAccent,
              thickness: 3,
            ),


            Container(
              height: 470,
              child: Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(28.0713516, -15.45598),
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
                      markers: [
                        new Marker(
                          width: 80.0,
                          height: 80.0,
                          point: new LatLng(itemsList[0].latitud, itemsList[0].longitud),
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
                        ),

                        new Marker(
                            width: 80.0,
                            height: 80.0,
                            point: new LatLng(itemsList[1].latitud, itemsList[1].longitud),
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
                        ),

                        new Marker(
                            width: 80.0,
                            height: 80.0,
                            point: new LatLng(itemsList[2].latitud, itemsList[2].longitud),
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
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
          )
      ),
    );

  }
}