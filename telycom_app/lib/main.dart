import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'AuthCall.dart';
import 'Token.dart';
import 'l10n/l10n.dart';
import "misIncidencias.dart";
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // TODO: uncomment the line below after codegen
        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,

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
  String usuario = "";
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
            AppLocalizations.of(context).sBnoUserWarning,
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
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/background.png'),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 150),
                      child: Image(
                        width: 300,
                        image: AssetImage('images/logo.png'),
                      )),

              Container(
                margin: EdgeInsets.only(bottom: 30.0, left: 50.0, right: 50.0),
                height: 200,
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),),
                  elevation: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45, top: 25, left: 15, right: 15),
                        child: TextField(
                            enabled: _isTextFieldEnable,
                            controller:textFieldController,
                            //la llave es necesaria para realizar el test de integración
                            key: Key('user'),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(),
                              labelText: 'Usuario',
                            ),
                            style:TextStyle(
                              fontSize: 20,
                              color:Colors.black,
                            )
                        ),
                      ),

                      SizedBox(),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: EdgeInsets.only(left: 22, right:22, top: 10, bottom: 10),
                        ),
                        child: Text('Entrar', style: TextStyle(fontSize: 22, color: Colors.white)),
                        //null cuando isbuttondisabled es true y pulsandoEntrar cuando es false
                        onPressed: _isButtonDisabled ? null : _pulsandoEntrar,
                      ),
                    ],
                  ),
                ),
              ),


                  // Comprobando el loading
                  cargando ? FutureBuilder<Token>(
                          future: futureToken,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.statusTelyAPI == '200' || snapshot.data.statusTelyAPI == '202' || snapshot.data.statusTelyAPI == '203') {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MisIncidencias(tk: snapshot.data.tk,))).then((value) {
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
            ],
        ),
      ),
          ),
    )
    );
  }
}


