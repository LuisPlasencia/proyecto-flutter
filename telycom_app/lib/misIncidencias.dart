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
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.'),
  ];

  Color colorTarjeta;


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
    return  Scaffold(
          appBar: AppBar(
            title: Text("Mis incidencias"),
          ),
          body: Column(children: [
            new Expanded(
              child: Row(
                children: [
                  new Expanded(
                    child: ListView.builder(
                      itemCount: itemsList.length,
                      itemBuilder: (context, index) {
                        // Para cambiar el color de la tarjeta
                        if(itemsList[index].state == "Atendido"){
                            colorTarjeta = Colors.green;
                        } else {
                          colorTarjeta = Colors.red;
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
                Container(
                  height: 470,
                  child: Flexible(
                    child: FlutterMap(
                      options: MapOptions(
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
                ),
              ],
            )
          );

  }
}
