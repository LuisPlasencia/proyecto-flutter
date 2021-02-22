import 'package:flutter/material.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Navigation Basics',
      home: FirstRoute(),
    );
  }
}

class FirstRoute extends StatelessWidget {

  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:SystemUiOverlayStyle(
        // statusBarColor: Colors.transparent, //i like transaparent :-)
        systemNavigationBarColor: Colors.grey[800], // navigation bar color
        // statusBarIconBrightness: Brightness.dark, // status bar icons' color
        // systemNavigationBarIconBrightness:Brightness.dark, //navigation bar icons' color
    ),

    child: Scaffold(
      resizeToAvoidBottomPadding: false,
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Image(
                width: 300,
                image: AssetImage('images/logo.png'),
              )
            ),

            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, left: 50.0, right: 50.0),
                  child: TextField(
                      controller:textFieldController,
                      //la llave es necesaria para realizar el test de integración
                      key: Key('user'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Usuario',
                      ),

                      style:TextStyle(
                        fontSize: 20,
                        color:Colors.black,
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),

                  child: TextField(
                      obscureText: true,
                      controller:textFieldController2,
                      key: Key('password'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),

                      style:TextStyle(
                        fontSize: 20,
                        color:Colors.black,
                      )
                  ),
                ),
              ],
            ),


            Container(
              // margin: const EdgeInsets.only(bottom: 80.0),
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
          ],
        ),
      ),
    )
    );
  }
}

// class FirstRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       Align(
//         alignment: Alignment.bottomCenter,
//         child:
//         Container(
//           margin: const EdgeInsets.only(bottom: 80.0),
//           child: RaisedButton(
//             color: Colors.blue,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18.0),
//                 side: BorderSide(color: Colors.black)
//             ),
//             padding: EdgeInsets.only(left: 50, right:50, top: 10, bottom: 10),
//             child: Text('Entrar', style: TextStyle(fontSize: 26, color: Colors.white)),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MisIncidencias()),
//               );
//             },
//           ),
//         ),
//       ),
//
//     );
//   }
// }



