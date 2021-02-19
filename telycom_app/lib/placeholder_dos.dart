import 'package:flutter/material.dart';

class PlaceholderWidgetDos extends StatelessWidget {

  PlaceholderWidgetDos();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30,left: 3, right: 3),
          padding: const EdgeInsets.all(3.0),
         child: TextField(
           decoration: InputDecoration(
             border: OutlineInputBorder(),
             labelText: 'Introduzca su mensaje',
           ),
         ),
        ),

        RaisedButton(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)
          ),
          padding: EdgeInsets.only(left: 50, right:50, top: 10, bottom: 10),
          child: Text('Enviar', style: TextStyle(fontSize: 26, color: Colors.white)),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => MisIncidencias()),
            // );
          },
        ),
      ],
    );
  }
}