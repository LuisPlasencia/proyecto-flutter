import 'package:flutter/material.dart';
import "misIncidencias.dart";


void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Align(
        alignment: Alignment.bottomCenter,
        child:
        Container(
          margin: const EdgeInsets.only(bottom: 80.0),
          child: RaisedButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
            ),
            padding: EdgeInsets.only(left: 50, right:50, top: 10, bottom: 10),
            child: Text('Entrar', style: TextStyle(fontSize: 26, color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MisIncidencias()),
              );
            },
          ),
        ),
      ),

    );
  }
}



