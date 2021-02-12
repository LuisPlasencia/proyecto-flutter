import 'package:flutter/material.dart';
import "misIncidencias.dart";

void main() {
  runApp(MaterialApp(
    title: '',
    home: DetalleInicidencias(),
  ));
}

class DetalleInicidencias extends StatelessWidget {
  final String creation;
  final String reference;
  final String state;
  final String direction;
  final String description;

  DetalleInicidencias(
      {Key key,
      @required this.state,
      this.creation,
      this.reference,
      this.direction,
      this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(reference)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Card(
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

          ],
        )
    );
  }
}
