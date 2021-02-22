import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:telycom_app/main.dart';
import 'package:telycom_app/misIncidencias.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets("No se ha escrito nombre de usuario, lo que impide el paso de pantalla", (WidgetTester tester) async{
    await tester.pumpWidget(MyApp());
    final texto = "holaaaaaaaaaaaaaaaaaaaaaaa";
    await tester.enterText(find.byKey(Key('user')), texto);
    expect(find.text(texto), findsWidgets);

    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('YES')));
    await tester.pumpAndSettle();
    expect(find.text(texto), findsWidgets);
  });


  // testWidgets("Comprobamos que el texto que escribimos concuerda", (WidgetTester tester) async{
  //   await tester.pumpWidget(MyApp());
  //
  //   final inputText = 'hola soy el sojha';
  //   await tester.enterText(find.byKey(Key('user')),inputText);
  //   await tester.pumpAndSettle();
  //   expect(find.text('hola soy el sojha'),findsOneWidget);
  // });
  //
  // testWidgets("Paso de pantalla a Mis Incidencias", (WidgetTester tester) async{
  //   await tester.pumpWidget(MyApp());
  //
  //   await tester.tap(find.byType(RaisedButton));
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(MisIncidencias), findsWidgets);
  // });

  // testWidgets("Paso de pantalla a Mis Incidencias no se muestra las incidencias", (WidgetTester tester) async{
  //   await tester.pumpWidget(MyApp());
  //
  //   await tester.tap(find.byType(RaisedButton));
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(MisIncidencias), findsWidgets);
  //   expect(find.byType(ListView), findsNothing);
  // });

  // testWidgets("Paso de pantalla a Mis Incidencias SE muestra las incidencias", (WidgetTester tester) async{
  //   await tester.pumpWidget(MyApp());
  //
  //   await tester.tap(find.byType(RaisedButton));
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(MisIncidencias), findsWidgets);
  //   await tester.tap(find.byType(ExpansionTile));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(ListTile), findsWidgets);
  // });

  testWidgets("En la pantalla Mis incidencias: pulsamos primera card de la lista -> icono", (WidgetTester tester) async{
    await tester.pumpWidget(MyApp());

      await tester.tap(find.byType(RaisedButton));

      await tester.pumpAndSettle();

      expect(find.byType(MisIncidencias), findsWidgets);

      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byKey(Key('listElement1')));
      await tester.pumpAndSettle();

      final latitudCenter = 28.0713516;
      final longitudCenter = -15.45598;

     expect(2+2, equals(4));


  });
}
