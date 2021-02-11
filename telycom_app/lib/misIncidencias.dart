import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import "ElementList.dart";
import "main.dart";
import "Mapa.dart";


class MisIncidencias extends StatelessWidget {
  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No Atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No Atendido', 'Las Palmas G.C.'),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return Card(
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
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: " | ",
                                    style: TextStyle(color: Colors.deepOrange)),
                                TextSpan(
                                    text: itemsList[index].reference,
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: " | ",
                                    style: TextStyle(color: Colors.deepOrange)),
                                TextSpan(
                                    text: itemsList[index].state,
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: " | ",
                                    style: TextStyle(color: Colors.deepOrange)),
                                TextSpan(
                                    text: itemsList[index].direction,
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('images/bear.png'),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

        ]));
  }
}
