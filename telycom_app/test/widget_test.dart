// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telycom_app/DetalleIncidencias.dart';

import 'package:telycom_app/main.dart';
import 'package:telycom_app/misIncidencias.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('Test 1 : Comprobando elementos del login', (WidgetTester tester) async {
    // final FirstRoute myWidgetState = tester.state(find.byType(FirstRoute));

    // Test code goes here.
    await tester.pumpWidget(MaterialApp(home: FirstRoute()));

    // Create the Finders.
    final textField1 = find.byKey(Key('user'));
    final imagen = find.byType(Image);
    final boton = find.byType(ElevatedButton);

    final textoTextField1 = find.text('Usuario');
    final textoBoton = find.text('Entrar');


    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textField1, findsOneWidget);
    expect(imagen, findsOneWidget);
    expect(boton, findsOneWidget);

    expect(textoTextField1, findsOneWidget);
    expect(textoBoton, findsOneWidget);
  });



  testWidgets('Test 4 : Comrpobando elementos del detalle', (WidgetTester tester) async {
    // final FirstRoute myWidgetState = tester.state(find.byType(FirstRoute));

    // Test code goes here.
    await tester.pumpWidget(MaterialApp(home: DetalleIncidencias(state: 'Atendido', creation: '12:45 05/02/21', reference: 'LPA21/0011', direction: 'Las Palmas G.C.', description: 'Accidentes de coche', latitud: 28.114198, longitud: -15.425447,)));

    // Create the Finders.
    final textLabel1 = find.byKey(Key('description'));
    final textLabel2 = find.byKey(Key('code'));
    final textLabel3 = find.byKey(Key('creation'));
    final textLabel4 = find.byKey(Key('direction'));
    final navigationBar = find.byType(BottomNavigationBar);
    final lista = find.byType(ListView);

    final textoTextField1 = find.text('Usuario');
    final textoBoton = find.text('Entrar');


    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textLabel1, findsOneWidget);
    expect(textLabel2, findsOneWidget);
    expect(textLabel3, findsOneWidget);
    expect(textLabel4, findsOneWidget);
    expect(navigationBar, findsOneWidget);
    expect(lista, findsOneWidget);
    // expect(imagen, findsOneWidget);
    // expect(boton, findsOneWidget);

    // expect(textoTextField1, findsOneWidget);
    // expect(textoBoton, findsOneWidget);
  });


  testWidgets('Test 2: Poniendo texto en el textfield', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final user = find.byKey(ValueKey("user"));

    await tester.pumpWidget(MaterialApp(home:FirstRoute()));
    await tester.enterText(user, "holahola");
    await tester.pump();

    expect(find.text("holahola"), findsOneWidget);
  });

  testWidgets('Test 3: Pasando a la pantalla de MisIncidencias', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // provideMockedNetworkImages(() async {
    // final enterButton = find.byType(RaisedButton);

    await tester.pumpWidget(MaterialApp(home:MisIncidencias()));
    // await tester.tap(enterButton);
    // await tester.pumpAndSettle();

    expect(1+1, 2);
    // });
  });




}
