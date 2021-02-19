import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telycom_app/SucesosList.dart';
import 'package:telycom_app/placeholder_tres.dart';
import 'placeholder_widget.dart';
import 'placeholder_dos.dart';
import 'placeholder_cuatro.dart';

void main() {
  runApp(MaterialApp(
    title: '',
    home: DetalleIncidencias(),
  ));
}

class DetalleIncidencias extends StatefulWidget {
  final String creation;
  final String reference;
  final String state;
  final String direction;
  final String description;
  final double latitud;
  final double longitud;

  // Constructor?
  DetalleIncidencias(
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
  _DetalleIncidencias createState() => new _DetalleIncidencias(
      creation, reference, state, direction, description, latitud, longitud);
}

class _DetalleIncidencias extends State<DetalleIncidencias> {
  String creation;
  String reference;
  String state;
  String direction;
  String description;
  double latitud;
  double longitud;

  int _currentIndex = 0;

  List<Widget> _children;

  _DetalleIncidencias(this.creation, this.reference, this.state, this.direction,
      this.description, this.latitud, this.longitud);

  void onTabTapped(int index){
    setState(() {
      this._currentIndex = index;
    });
  }

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

  Color colorAppBar;

  @override
  Widget build(BuildContext context) {
    if (state == "Atendido") {
      colorAppBar = Colors.green[400];
    } else {
      colorAppBar = Colors.red[400];
    }

    // tiene que ir aqui porque para que reconozca las variables
    _children = [
      // Sucesos
      PlaceholderWidget(state: this.state ,creation: this.creation, reference: this.reference, direction:  this.direction, description:  this.description, latitud: this.latitud, longitud: this.longitud,),
      // Mensaje
      PlaceholderWidgetDos(),
      // Camara
      PlaceholderWidgetTres(),
      // Mapa
      PlaceholderWidgetCuatro(state: this.state ,creation: this.creation, reference: this.reference, direction:  this.direction, description:  this.description,  latitud: this.latitud, longitud: this.longitud, ),
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorAppBar,
          title: Text(reference),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.autorenew),
              tooltip: 'Actualizar',
              // cuando lo mantenemos pulsado no saldra este texto
              onPressed: () {

              },
            ),
          ],
        ),

      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.grey[800],
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.wysiwyg),
              title: new Text("Sucesos"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_comment),
              title: new Text("Mensaje"),

            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_photo_alternate),
              title: new Text("Imagen"),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_location),
              title: new Text("Mapa"),
            ),
          ],
        ),
      ),

        body:
        _children[_currentIndex],
      // Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //
      //       Container(
      //         width: double.infinity,
      //         child: Card(
      //           color: Colors.grey,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 10.0),
      //             child: Text(
      //               "Descripción",
      //               style: TextStyle(fontSize: 20),
      //               textAlign: TextAlign.left,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child: Text(
      //           description,
      //           style: TextStyle(fontSize: 15),
      //           textAlign: TextAlign.right,
      //         ),
      //       ),
      //       Container(
      //         width: double.infinity,
      //         child: Card(
      //           color: Colors.grey,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 10.0),
      //             child: Text(
      //               "Código",
      //               style: TextStyle(fontSize: 20),
      //               textAlign: TextAlign.left,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child: Text(
      //           reference,
      //           style: TextStyle(fontSize: 15),
      //           textAlign: TextAlign.right,
      //         ),
      //       ),
      //       Container(
      //         width: double.infinity,
      //         child: Card(
      //           color: Colors.grey,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 10.0),
      //             child: Text(
      //               "Creación",
      //               style: TextStyle(fontSize: 20),
      //               textAlign: TextAlign.left,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child: Text(
      //           creation,
      //           style: TextStyle(fontSize: 15),
      //           textAlign: TextAlign.right,
      //         ),
      //       ),
      //       Container(
      //         width: double.infinity,
      //         child: Card(
      //           color: Colors.grey,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 10.0),
      //             child: Text(
      //               "Dirección",
      //               style: TextStyle(fontSize: 20),
      //               textAlign: TextAlign.left,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child: Text(
      //           direction,
      //           style: TextStyle(fontSize: 15),
      //           textAlign: TextAlign.right,
      //         ),
      //       ),
      //       Divider(
      //         thickness: 3,
      //         color: Colors.black,
      //       ),
      //       new Expanded(
      //         child: Row(
      //           children: [
      //             new Expanded(
      //               child: ListView.builder(
      //                 itemCount: sucesosList.length,
      //                 itemBuilder: (context, index) {
      //                   if (sucesosList[index].tipoMsg == "atendido") {
      //                     return Card(
      //                       child: Container(
      //                         child: ListTile(
      //                           // onTap: () {
      //                           //   Navigator.push(
      //                           //       context,
      //                           //       MaterialPageRoute(
      //                           //         builder: (context) => DetalleIncidencias(
      //                           //           // creation: itemsList[index].creation,
      //                           //           // reference: itemsList[index].reference ,
      //                           //           // state: itemsList[index].state,
      //                           //           // direction: itemsList[index].direction,
      //                           //           // description: itemsList[index].description,
      //                           //         ),
      //                           //       ));
      //                           // },
      //                           title: Row(
      //                             children: [
      //                               RichText(
      //                                 text: TextSpan(
      //                                   children: <TextSpan>[
      //                                     TextSpan(
      //                                       text: sucesosList[index].fecha,
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           color: Colors.black),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               SizedBox(width: 20),
      //                               RichText(
      //                                 text: TextSpan(
      //                                   text: "Suceso atendido por " +
      //                                       sucesosList[index].entidad,
      //                                   style: TextStyle(
      //                                       fontSize: 16, color: Colors.black),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   } else {
      //                     return Card(
      //                       child: Container(
      //                         child: ListTile(
      //                           // onTap: () {
      //                           //   Navigator.push(
      //                           //       context,
      //                           //       MaterialPageRoute(
      //                           //         builder: (context) => DetalleIncidencias(
      //                           //           // creation: itemsList[index].creation,
      //                           //           // reference: itemsList[index].reference ,
      //                           //           // state: itemsList[index].state,
      //                           //           // direction: itemsList[index].direction,
      //                           //           // description: itemsList[index].description,
      //                           //         ),
      //                           //       ));
      //                           // },
      //                           title: Row(
      //                             children: [
      //                               RichText(
      //                                 text: TextSpan(
      //                                   text: sucesosList[index].fecha,
      //                                   style: TextStyle(
      //                                       fontSize: 16, color: Colors.black),
      //                                 ),
      //                               ),
      //                               SizedBox(width: 20),
      //                               RichText(
      //                                 text: TextSpan(
      //                                   children: <TextSpan>[
      //                                     TextSpan(
      //                                       text: "Incidente creado por " +
      //                                           sucesosList[index].entidad,
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\nTipificación:",
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           fontWeight: FontWeight.bold,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\n" +
      //                                           sucesosList[index].tipificacion,
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\nLocalización:",
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           fontWeight: FontWeight.bold,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\n" +
      //                                           sucesosList[index].localizacion,
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\nAgencia asignada:",
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           fontWeight: FontWeight.bold,
      //                                           color: Colors.black),
      //                                     ),
      //                                     TextSpan(
      //                                       text: "\n" +
      //                                           sucesosList[index].agencia,
      //                                       style: TextStyle(
      //                                           fontSize: 16,
      //                                           color: Colors.black),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   }
      //                 },
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
    );
  }
}


