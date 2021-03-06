// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:telycom_app/screens/DetalleIncidencias.dart';
import 'package:telycom_app/screens/Login.dart';
import 'package:telycom_app/screens/MisIncidencias.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.

  testWidgets('Test 1 : Comprobando elementos del login', (WidgetTester tester) async {
    // final FirstRoute myWidgetState = tester.state(find.byType(FirstRoute));

    // Test code goes here.
    await tester.pumpWidget(Login());

    // Create the Finders.
    final textField1 = find.byKey(Key('user'));
    final imagen = find.byType(Image);
    final boton = find.byType(ElevatedButton);

    final textoTextField1 = find.text('User');
    final textoBoton = find.text('Login');


    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textField1, findsOneWidget);
    expect(imagen, findsOneWidget);
    expect(boton, findsOneWidget);

    expect(textoTextField1, findsOneWidget);
    expect(textoBoton, findsOneWidget);
  });

  testWidgets('Test 2: Escribiendo texto en el textfield', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final user = find.byKey(ValueKey("user"));

    await tester.pumpWidget(Login());
    await tester.enterText(user, "holahola");
    await tester.pump();

    expect(find.text("holahola"), findsOneWidget);
  });

  testWidgets('Test 3: Comprobando snackbar sin introducir usuario', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final enterButton = find.byType(ElevatedButton);

    await tester.pumpWidget(Login());
    await tester.tap(enterButton);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar),findsOneWidget);

  });

  testWidgets('Test 4: Introducir usuario y tap', (WidgetTester tester) async {
    // Build our app and trigger a frame.


    // provideMockedNetworkImages(() async {
      await tester.pumpWidget(Login());
      final user = find.byKey(ValueKey("user"));
      final enterButton = find.byType(ElevatedButton);


      await tester.enterText(user, "holahola");
      await tester.pumpAndSettle();
      await tester.tap(enterButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar),findsOneWidget);
    // });
  });

  testWidgets('Test x : Comrpobando elementos del detalle', (WidgetTester tester) async {
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
}
