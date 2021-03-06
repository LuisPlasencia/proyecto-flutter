import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telycom_app/httpService/Suceso.dart';

import 'package:telycom_app/l10n/l10n.dart';
import 'package:telycom_app/httpService/AuthCall.dart';
import 'package:telycom_app/httpService/Token.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'dart:developer' as developer;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'MisIncidencias.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // needed if you intend to initialize in the main function
  WidgetsFlutterBinding.ensureInitialized();


// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      onDidReceiveLocalNotification:  _FirstRouteState().onDidReceiveLocalNotification);

  final MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: _FirstRouteState().selectNotification);


  runApp(Login());
}

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
  Future<Suceso> futureSuceso;

  // IMEI
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _isButtonDisabled = false;
    _isTextFieldEnable = true;
    pushNotification(1, 'Telycom', "Bienvenido");

  }

  
  /// Se ejecuta cuando pulsamos sobre una notificación
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    if(payload == 'item 1'){
      print("Has pulsado sobre la notificación de Login");
      // HAZ ALGO
    }

    if(payload == 'item 2'){
      print("Has pulsado sobre la notificación de Mis Incidencias");
      // HAZ ALGO
    }

  }

 /// Método opcional para versiones antiguas de iOS (Notificacion push)
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MisIncidencias(tk: '53db87de89a54c17b30df4111cfac14a', imei: _platformImei, username: usuario,)
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void showSnackBar(String text) {
    final snackbar = SnackBar(
        backgroundColor: Colors.yellow,
        content: Text(
          text,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /// Para pulsar a Entrar
  void _pulsandoEntrar() {
    if (textFieldController.text != "") {
      setState(() {
        cargando = true;
        _isButtonDisabled = true;
        _isTextFieldEnable = false;
        usuario = textFieldController.text;
        developer.log(usuario.toString(), name: "emote");
        futureToken =
            AuthCall.fetchToken(usuario).timeout(Duration(seconds: 20));
      });
    } else if (_platformImei ==
        'Failed to get platform version.') { // no se pudo obtener el IMEI del dispositivo
      showSnackBar(AppLocalizations
          .of(context)
          .sBnoImeiFail,);
    } else { // Si esta vacio el textfield
      showSnackBar(AppLocalizations
          .of(context)
          .sBnoUserWarning,);
    }
  }

  /// Notificaciones Push
  Future pushNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your event id', 'your event name', 'your event description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: 'item ' + id.toString());
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
          body: Transform.scale(scale: 1,
          child:Container(
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
                    width: 400,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),),
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08, top: MediaQuery.of(context).size.height * 0.03, left: 15, right: 15),
                            child: TextField(
                              maxLength: 30,
                              enabled: _isTextFieldEnable,
                              controller:textFieldController,
                              //la llave es necesaria para realizar el test de integración
                              key: Key('user'),

                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                border: OutlineInputBorder(),
                                labelText: AppLocalizations.of(context).labelUser,
                                counterText: "",
                              ),
                              style:TextStyle(
                                fontSize: 18,
                                color:Colors.black,
                              )
                          ),
                      ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
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
                                    builder: (context) => MisIncidencias(tk: snapshot.data.tk, imei: _platformImei, username: usuario,)));
                                setState(() {
                                  cargando = false;
                                  _isButtonDisabled = false;
                                  _isTextFieldEnable = true;
                                });
                            }
                          );
                          return new Container(
                            height: 75,
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

                        return emptyContainer();
                      }
                      // By default
                      return Container(
                      height: 73,
                      padding: EdgeInsets.only(bottom: 15),
                      child: SpinKitHourGlass(color: Colors.white));
                    },
                  )
                      : emptyContainer(),
                ],
              ),
            ),
          ),
          ),

        ));
  }

  Container emptyContainer() {
    return new Container(
      height: 73,
      padding: EdgeInsets.only(bottom: 15),
    );
  }
}
