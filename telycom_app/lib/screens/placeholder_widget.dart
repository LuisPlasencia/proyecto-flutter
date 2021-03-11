import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:telycom_app/SucesosList.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:telycom_app/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _portraitMode();
          } else {
            return _landscapeMode();
          }
        },
      );
  }

  Widget _portraitMode() {
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
              child: Text(AppLocalizations.of(context).description,
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
              child: Text(AppLocalizations.of(context).code,
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
              child: Text(AppLocalizations.of(context).creation,
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
              child: Text(AppLocalizations.of(context).direction,
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
          child: ListView.builder(
            itemCount: sucesosList.length,
            itemBuilder: (context, index) {
              if (sucesosList[index].tipoMsg == "atendido") {
                return Card(
                  child: Container(
                    child: ListTile(
                      title: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: sucesosList[index].fecha,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context).eventOpenedBy + " " + sucesosList[index].entidad,
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
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

                      title: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: sucesosList[index].fecha,
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 20),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppLocalizations.of(context).incidentCreatedBy + " " + sucesosList[index].entidad,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + AppLocalizations.of(context).typification,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                  "\n" + sucesosList[index].tipificacion,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + AppLocalizations.of(context).localization,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                  "\n" + sucesosList[index].localizacion,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" +  AppLocalizations.of(context).agencyAsigned,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + sucesosList[index].agencia,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
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
    );
  }
  Widget _landscapeMode() {
      return OrientationBuilder(
        builder: (context, orientation){
          return Container(
            margin: EdgeInsets.only(top: 5),
            child: new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: sucesosList.length,
              itemBuilder: (BuildContext context, int index) {
                if (sucesosList[index].tipoMsg == "atendido") {
                return new Container(
                  // margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(left:10, right:10, top: 10, bottom: 10),
                  color: Colors.grey[350],
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: sucesosList[index].fecha,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context).eventOpenedBy + " " + sucesosList[index].entidad,
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
                } else{
                  return new Container(
                    padding: EdgeInsets.only(left:10, right:10, top: 10, bottom: 10),
                    color: Colors.grey[350],
                    child: Row(
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
                                  text: AppLocalizations.of(context).incidentCreatedBy + " " + sucesosList[index].entidad,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + AppLocalizations.of(context).typification,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                  "\n" + sucesosList[index].tipificacion,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + AppLocalizations.of(context).localization,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                  "\n" + sucesosList[index].localizacion,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" +  AppLocalizations.of(context).agencyAsigned,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: "\n" + sucesosList[index].agencia,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  );
                }
              },
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 1 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
        ),
          );
    });
  }


}
