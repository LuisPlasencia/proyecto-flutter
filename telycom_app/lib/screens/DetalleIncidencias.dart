import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telycom_app/SucesosList.dart';
import 'package:telycom_app/screens/placeholder_cuatro.dart';
import 'package:telycom_app/screens/placeholder_dos.dart';
import 'package:telycom_app/screens/placeholder_tres.dart';
import 'placeholder_widget.dart';
import 'package:telycom_app/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MaterialApp(
    title: 'IncidenciasDetail',
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
      @required this.creation,
      @required this.reference,
      @required this.direction,
      @required this.description,
      @required this.latitud,
      @required this.longitud})
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
              tooltip: AppLocalizations.of(context).renewButtonHint,
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
          unselectedItemColor: Colors.yellow,
          selectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.wysiwyg),
              label: AppLocalizations.of(context).bNBI_events,
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_comment),
              label: AppLocalizations.of(context).bNBI_message,

            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_photo_alternate),
              label: AppLocalizations.of(context).bNBI_image,
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.add_location),
              label: AppLocalizations.of(context).bNBI_map,
            ),
          ],
        ),
      ),

        body:
        _children[_currentIndex],

    );
  }
}


