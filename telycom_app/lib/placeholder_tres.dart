import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlaceholderWidgetTres extends StatefulWidget {
  @override
  _PlaceholderWidgetTresState createState() => _PlaceholderWidgetTresState();
}

class _PlaceholderWidgetTresState extends State<PlaceholderWidgetTres> {
  File _image;
  final picker = ImagePicker();

  // Este método abre la camara para sacar una foto
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      // Si existe imagen presentamos la imagen
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget comprobarImagen() {
    if (_image != null) {
      return RaisedButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black)),
        padding: EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
        child:
        Text('Enviar', style: TextStyle(fontSize: 26, color: Colors.white)),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MisIncidencias()),
          // );
        },
      );
    } else {
      return new Container(width: 0, height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mostramos el botón para enviar la imagen si existe
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              // (ternary operator (el if en el UI))  =>  condicion +  ? (= {}) + : (= else)
              // otra forma es ponerlo en un método : child: getWidget()
              //
              //                                      Widget getWidget() {
              //                                          if (x > 5) ... }
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),

            comprobarImagen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      );
  }
}
