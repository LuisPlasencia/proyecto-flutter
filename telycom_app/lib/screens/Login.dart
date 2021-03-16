import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telycom_app/l10n/l10n.dart';
import 'package:telycom_app/httpService/AuthCall.dart';
import 'package:telycom_app/httpService/Token.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'dart:developer' as developer;


import 'MisIncidencias.dart';

void main() async => runApp(Login());

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Login',
      home: FirstRoute(),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // uncomment the line below after codegen
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,

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

  // IMEI
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _isButtonDisabled = false;
    _isTextFieldEnable = true;
  }

  //
  void _pulsandoEntrar() {
    if (textFieldController.text != "") {
      setState(() {
        cargando = true;
        _isButtonDisabled = true;
        _isTextFieldEnable = false;
        usuario = textFieldController.text;
        developer.log(usuario.toString(),name:"emote");
        futureToken = AuthCall.fetchToken(usuario).timeout(Duration(seconds: 20));
      });
    } else {
      final snackbar = SnackBar(
          backgroundColor: Colors.yellow,
          content: Text(
            AppLocalizations.of(context).sBnoUserWarning,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
      developer.log("Este es el IMEI: "+_platformImei, name: 'my.app.category');
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      // margin: EdgeInsets.only(top: 150),
                      child: Image(
                        width: 300,
                        image: AssetImage('images/logo.png'),
                      )),
                  // Text('Running on: $_platformImei\n is equal to : $uniqueId'),

              Container(
                margin: EdgeInsets.only( left: 50.0, right: 50.0),
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
                              labelText: AppLocalizations.of(context).labelUser,
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
                        child: Text(AppLocalizations.of(context).buttonSubmitLogin, style: TextStyle(fontSize: 22, color: Colors.white)),
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
                              if (snapshot.data.statusTelyAPI == '200' ||
                                  snapshot.data.statusTelyAPI == '202' ||
                                  snapshot.data.statusTelyAPI == '203') {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MisIncidencias(tk: snapshot.data.tk,))).then((value) {
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
                                        AppLocalizations.of(context).sBErrorText + ": " + snapshot.data.statusTelyAPI,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ));

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  // Add Your Code here.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                  setState(() {
                                    cargando = false;
                                    _isButtonDisabled = false;
                                    _isTextFieldEnable = true;
                                  });
                                });

                                return new Container(
                                  height: 75,
                                  padding: EdgeInsets.only(bottom: 15),
                                );
                              }
                            } else if (snapshot.hasError) {
                              developer.log(snapshot.error.toString(),name:"error");
                              SnackBar snackbar;
                              snackbar = SnackBar(
                                  backgroundColor: Colors.yellow,
                                  content: Text(
                                    AppLocalizations.of(context).sBTimeoutText,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ));

                                // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                // Add Your Code here.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                                setState(() {
                                  cargando = false;
                                  _isButtonDisabled = false;
                                  _isTextFieldEnable = true;
                                });
                              });

                              return new Container(
                                height: 75,
                                padding: EdgeInsets.only(bottom: 15),
                              );
                            }
                            // By default, show a loading spinner.
                            return Container(
                                height: 75,
                                padding: EdgeInsets.only(bottom: 15),
                                child: SpinKitHourGlass(color: Colors.white));
                          },
                        )
                        : new Container(
                          height: 75,
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}