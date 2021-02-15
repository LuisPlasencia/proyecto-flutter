import 'package:flutter/material.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';

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

  Color colorAppBar;

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

    if(state == "Atendido"){
      colorAppBar = Colors.green[400];
    } else {
      colorAppBar = Colors.red[400];
    }

    return Scaffold(
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.grey[800],
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.white,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))), // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(Icons.wysiwyg),
                title: new Text("Incidencias"),
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


        appBar: AppBar(
            backgroundColor: colorAppBar,
            title:
            Text(reference)

        ),
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
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            Container(
              width: double.infinity,
              child: Card(
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "09:56\n09/02/21 " + " Suceso atendido por TELYCOM1",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Card(
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "11:23\n09/02/21",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 20),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Incidente creado por TELYCOM1",
                              style: TextStyle(fontSize: 16),
                            ),

                            TextSpan(
                              text: "\nTipificación:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),
                            ),
                            TextSpan(
                              text: "\n10:30 Tráfico DEFAULT",
                              style: TextStyle(fontSize: 16),
                            ),

                            TextSpan(
                              text: "\nLocalización:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),
                            ),
                            TextSpan(
                              text: "\nLas Palmas de Gran Canaria",
                              style: TextStyle(fontSize: 16),
                            ),

                            TextSpan(
                              text: "\nAgencia asignada:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),
                            ),
                            TextSpan(
                              text: "\nPolicia Local",
                              style: TextStyle(fontSize: 16),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  // Text(
                  //   "11:23\n09/02/21 "+" Incidente creado por TELYCOM1",
                  //   style: TextStyle(fontSize: 16),
                  //   textAlign: TextAlign.left,
                  // ),
                ),
              ),
            ),
            // Spacer(),
            // Container(
            //   color: Colors.grey[800],
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Card(
            //         color: Colors.grey[800],
            //         child: Container(
            //             padding: EdgeInsets.all(20.0),
            //             child: Image(
            //               image: AssetImage('images/email.png'),
            //               width: 30,
            //               height: 30,
            //             )),
            //       ),
            //       Card(
            //         color: Colors.grey,
            //         child: Container(
            //             padding: EdgeInsets.all(20.0),
            //             child: Image(
            //               image: AssetImage('images/image.png'),
            //               width: 30,
            //               height: 30,
            //             )),
            //       ),
            //       Card(
            //         color: Colors.grey,
            //         child: Container(
            //             padding: EdgeInsets.all(20.0),
            //             child: Image(
            //               image: AssetImage('images/placeholder.png'),
            //               width: 30,
            //               height: 30,
            //             )),
            //       ),
            //       Card(
            //         color: Colors.red[400],
            //         child: Container(
            //             padding: EdgeInsets.all(20.0),
            //             child: Image(
            //               image: AssetImage('images/log-out.png'),
            //               width: 30,
            //               height: 30,
            //             )),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
    );
  }
}
