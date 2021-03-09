import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'AuthCall.dart';
import 'Token.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Basics',
      home: FirstRoute(),
    );
  }
}

class FirstRoute extends StatefulWidget {
  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {

  final TextEditingController textFieldController = TextEditingController();
  Future<Token> futureToken;
  String usuario = "lolo";
  bool cargando = false;
  bool _isButtonDisabled;
  bool _isTextFieldEnable;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
    _isTextFieldEnable = true;
  }

  void _pulsandoEntrar(){
    if(textFieldController.text != ""){
      setState(() {
        cargando = true;
        _isButtonDisabled = true;
        _isTextFieldEnable = false;
        usuario = textFieldController.text;
        futureToken = AuthCall.fetchToken(usuario);
      });
    } else{
      final snackbar = SnackBar(
          backgroundColor: Colors.yellow,
          content: Text(
            "Ha de introducir un usuario",
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Bloqueo de pantalla en modo portrait
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          // statusBarColor: Colors.transparent, //i like transaparent :-)
          systemNavigationBarColor: Colors.grey[800], // navigation bar color
          // statusBarIconBrightness: Brightness.dark, // status bar icons' color
          // systemNavigationBarIconBrightness:Brightness.dark, //navigation bar icons' color
        ),
        child: Scaffold(
          //propiedad que utilizamos para que no se cambie el tamaño de la columna al abrir el teclado
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(20.0),
                    child: Image(
                      width: 300,
                      image: AssetImage('images/logo.png'),
                    )),


            Container(
              margin: EdgeInsets.only(bottom: 10.0, left: 50.0, right: 50.0),
              child: TextField(
                  enabled: _isTextFieldEnable,
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


                // Comprobando el loading

                cargando ? FutureBuilder<Token>(
                        future: futureToken,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.statusTelyAPI == '200' || snapshot.data.statusTelyAPI == '202' || snapshot.data.statusTelyAPI == '203') {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MisIncidencias())).then((value) {
                                    setState(() {
                                      cargando = false;
                                      _isButtonDisabled = false;
                                      _isTextFieldEnable = true;
                                    });
                                  });
                                });
                                return new Container(
                                  height: 100,
                                  padding: EdgeInsets.only(bottom: 15),
                                );
                            } else {
                                final snackbar = SnackBar(
                                    backgroundColor: Colors.yellow,
                                    content: Text(
                                      "Error: " + snapshot.data.statusTelyAPI,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ));

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  // Add Your Code here.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                });
                                setState(() {
                                  cargando = false;
                                  _isButtonDisabled = false;
                                  _isTextFieldEnable = true;
                                });
                                return new Container(
                                  height: 100,
                                  padding: EdgeInsets.only(bottom: 15),
                                );
                          }
                        } else if (snapshot.hasError) {
                          final snackbar = SnackBar(
                              backgroundColor: Colors.yellow,
                              content: Text(
                                snapshot.error.toString(),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ));
                          // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Add Your Code here.
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          });
                          setState(() {
                            cargando = false;
                            _isButtonDisabled = false;
                            _isTextFieldEnable = true;
                          });
                          return new Container(
                            height: 100,
                            padding: EdgeInsets.only(bottom: 15),
                          );
                        }
                        // By default, show a loading spinner.
                        return Container(
                            height: 100,
                            padding: EdgeInsets.only(bottom: 15),
                            child: SpinKitHourGlass(color: Colors.black));
                      },
                    )
                  : new Container(
                        height: 100,
                        padding: EdgeInsets.only(bottom: 15),
                    ),

            // FutureBuilder<Token>(
            //   future: futureToken,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text(
            //         snapshot.data.body
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text("${snapshot.error}");
            //     }
            //     // By default, show a loading spinner.
            //     return Container(
            //         padding: EdgeInsets.only(bottom:15),
            //         child: SpinKitHourGlass(color: Colors.white));
            //   },
            // ),

            Container(
              margin: EdgeInsets.only(bottom: 50.0),
              // margin: const EdgeInsets.only(bottom: 80.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)
                  ),
                  padding: EdgeInsets.only(left: 50, right:50, top: 10, bottom: 10),
                ),
                child: Text('Entrar', style: TextStyle(fontSize: 26, color: Colors.white)),
                //null cuando isbuttondisabled es true y pulsandoEntrar cuando es false
                onPressed: _isButtonDisabled ? null : _pulsandoEntrar,


                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MisIncidencias()),
                  // );

                  // textoError = 'horrible';


                  // FutureBuilder<Token>(
                  //   future: futureToken,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => MisIncidencias()),
                  //       );
                  //     } else if (snapshot.hasError) {
                  //       return Text("${snapshot.error}");
                  //     }
                  //     // By default, show a loading spinner.
                  //     return Container(
                  //         padding: EdgeInsets.only(bottom:15),
                  //         child: SpinKitHourGlass(color: Colors.white));
                  //   },
                  // );

              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}


