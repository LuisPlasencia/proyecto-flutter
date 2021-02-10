import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Align(
        alignment: Alignment.bottomCenter,
        child:
        Container(
          margin: const EdgeInsets.only(bottom: 80.0),
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
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
          ),
        ),
      ),

    );
  }
}

class ElementList {
  String _creation;
  String _reference;
  String _state;
  String _direction;

  ElementList(this._creation, this._reference, this._state, this._direction);

  String get creation => _creation;
  set creation(String value) {
    _creation = value;
  }

  String get reference => _reference;
  set reference(String value) {
    _reference = value;
  }

  String get state => _state;
  set state(String value) {
    _state = value;
  }

  String get direction => _direction;
  set direction(String value) {
    _direction = value;
  }
}

List<ElementList> itemsList = [
ElementList('12:45 05/02/21', 'LPA21/0011', 'No atendido', 'Las Palmas G.C.'),
ElementList('12:45 05/02/21', 'LPA21/0011', 'Atendido', 'Las Palmas G.C.'),
ElementList('12:45 05/02/21', 'LPA21/0021', 'No atendido', 'Las Palmas G.C.'),
];

class SecondRoute extends StatelessWidget {
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
                title: Text(itemsList[index]._direction),
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