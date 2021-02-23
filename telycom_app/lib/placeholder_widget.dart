import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telycom_app/ElementList.dart';
import 'package:telycom_app/SucesosList.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';
import "Mapa.dart";
import 'package:telycom_app/misIncidencias.dart';

import 'placeholder_widget.dart';

class PlaceholderWidget extends StatefulWidget {

  final String creation;
  final String reference;
  final String state;
  final String direction;
  final String description;
  final double latitud;
  final double longitud;

  // Constructor?
  PlaceholderWidget(
      {Key key,
        @required this.state,
        this.creation,
        this.reference,
        this.direction,
        this.description,
        this.latitud,
        this.longitud})
      : super(key: key);

  @override
  _PlaceholderWidget createState() => new _PlaceholderWidget(
      creation, reference, state, direction, description, latitud, longitud);
}

class _PlaceholderWidget extends State<PlaceholderWidget> {

  String creation;
  String reference;
  String state;
  String direction;
  String description;
  double latitud;
  double longitud;

  _PlaceholderWidget(this.creation, this.reference, this.state, this.direction,
      this.description, this.latitud, this.longitud);

  List<SucesosList> sucesosList = [
    SucesosList('TELYCOM1', '', '', '', '', '09:56 \n09/02/21', 'atendido'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: Card(
            key: Key("description"),
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Descripción",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          width: double.infinity,
          child: Card(
            key: Key("code"),
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Código",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            reference,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          width: double.infinity,
          child: Card(
            key: Key("creation"),
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Creación",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            creation,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          width: double.infinity,
          child: Card(
            key: Key("direction"),
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Dirección",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            direction,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
          ),
        ),
        Divider(
          thickness: 3,
          color: Colors.black,
        ),
        new Expanded(
          child: Row(
            children: [
              new Expanded(
                child: ListView.builder(
                  itemCount: sucesosList.length,
                  itemBuilder: (context, index) {
                    if (sucesosList[index].tipoMsg == "atendido") {
                      return Card(
                        child: Container(
                          child: ListTile(
                            // onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => DetalleIncidencias(
                            //           // creation: itemsList[index].creation,
                            //           // reference: itemsList[index].reference ,
                            //           // state: itemsList[index].state,
                            //           // direction: itemsList[index].direction,
                            //           // description: itemsList[index].description,
                            //         ),
                            //       ));
                            // },
                            title: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: sucesosList[index].fecha,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                RichText(
                                  text: TextSpan(
                                    text: "Suceso atendido por " +
                                        sucesosList[index].entidad,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: Container(
                          child: ListTile(
                            // onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => DetalleIncidencias(
                            //           // creation: itemsList[index].creation,
                            //           // reference: itemsList[index].reference ,
                            //           // state: itemsList[index].state,
                            //           // direction: itemsList[index].direction,
                            //           // description: itemsList[index].description,
                            //         ),
                            //       ));
                            // },
                            title: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: sucesosList[index].fecha,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 20),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Incidente creado por " +
                                            sucesosList[index].entidad,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\nTipificación:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\n" +
                                            sucesosList[index].tipificacion,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\nLocalización:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\n" +
                                            sucesosList[index].localizacion,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\nAgencia asignada:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "\n" +
                                            sucesosList[index].agencia,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}