import 'package:flutter/material.dart';
import "ElementList.dart";

class MisIncidencias extends StatelessWidget {

  List<ElementList> itemsList = [
    ElementList('12:45 05/02/21', 'LPA21/0011', 'No atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.'),
    ElementList('12:45 05/02/21', 'LPA21/0021', 'No atendido', 'Las Palmas G.C.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis incidencias"),
        ),
        body: ListView.builder(
          itemCount: itemsList.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                onTap: (){},
                title: Text(itemsList[index].direction),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'images/bear.png'
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}




