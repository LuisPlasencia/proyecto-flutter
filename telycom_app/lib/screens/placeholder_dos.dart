import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceholderWidgetDos extends StatelessWidget {

  PlaceholderWidgetDos();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30,left: 3, right: 3),
          padding: const EdgeInsets.all(3.0),
         child: TextField(
           decoration: InputDecoration(
             border: OutlineInputBorder(),
             labelText: AppLocalizations.of(context).textFieldHintEnterMessage,
           ),
         ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
            ),
            padding: EdgeInsets.only(left: 50, right:50, top: 10, bottom: 10),
          ),
          child: Text( AppLocalizations.of(context).submitButtonMessageTab, style: TextStyle(fontSize: 26, color: Colors.white)),
          onPressed: () {
          },
        ),

      ],
    );
  }
}