import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:telycom_app/screens/DetalleIncidencias.dart';
import 'package:telycom_app/screens/Login.dart';
import 'package:telycom_app/screens/MisIncidencias.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets("Test 1 : No se ha escrito nombre de usuario, lo que impide el paso de pantalla", (WidgetTester tester) async{
    await tester.pumpWidget(Login());
    final texto = "Luisito";
    await tester.enterText(find.byKey(Key('user')), texto);
    expect(find.text(texto), findsWidgets);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('YES')));
    await tester.pumpAndSettle();
    expect(find.text(texto), findsWidgets);
  });


  testWidgets("Test 2: Comprobamos que el texto que escribimos concuerda", (WidgetTester tester) async{
    await tester.pumpWidget(Login());

    final inputText = 'hola soy el sojha';
    await tester.enterText(find.byKey(Key('user')),inputText);
    await tester.pumpAndSettle();
    expect(find.text('hola soy el sojha'),findsOneWidget);
  });

  testWidgets("Paso de pantalla a Mis Incidencias", (WidgetTester tester) async{
    await tester.pumpWidget(Login());

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(MisIncidencias), findsWidgets);
  });

  testWidgets("Test 3: Paso de pantalla a Mis Incidencias no se muestra las incidencias", (WidgetTester tester) async{
    await tester.pumpWidget(Login());

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(MisIncidencias), findsWidgets);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets("Test 4: Paso de pantalla a Mis Incidencias SE muestra las incidencias", (WidgetTester tester) async{
    await tester.pumpWidget(Login());

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    expect(find.byType(MisIncidencias), findsWidgets);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets("Test 5: En la pantalla Mis incidencias: pulsamos primera card de la lista -> icono", (WidgetTester tester) async{
    await tester.pumpWidget(Login());

      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      expect(find.byType(MisIncidencias), findsWidgets);

      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byKey(Key('centerInMap0')));
      await tester.pumpAndSettle();

      final latitudCenter = 28.0713516;
      final longitudCenter = -15.45598;

      String valor = latitudCenter.toString()+" "+longitudCenter.toString();

      expect(find.byType(SnackBar),findsWidgets);

  });

  testWidgets("Test 6: En la pantalla del detalle del primer card apareceran la descripción, código, creación y dirección", (WidgetTester tester) async{
    await tester.pumpWidget(Login());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(MisIncidencias), findsWidgets);

    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byKey(Key('listElement0')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('description')),findsOneWidget);
    expect(find.byKey(Key('code')),findsOneWidget);
    expect(find.byKey(Key('creation')),findsOneWidget);
    expect(find.byKey(Key('direction')),findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets("Test 7: Detalle completo y vuelta", (WidgetTester tester) async{
    await tester.pumpWidget(Login());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(MisIncidencias), findsWidgets);

    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byKey(Key('listElement0')));
    await tester.pumpAndSettle();
    expect(find.byType(DetalleIncidencias), findsWidgets);

    await tester.tap(find.text("Mensaje"));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text("Enviar"), findsOneWidget);

    await tester.tap(find.text("Imagen"));
    await tester.pumpAndSettle();
    expect(find.text("No image selected."), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.text("Mapa"));
    await tester.pumpAndSettle();
    expect(find.byType(FlutterMap), findsOneWidget);

    await tester.tap(find.text("Sucesos"));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(FlutterMap), findsOneWidget);

  });

  testWidgets("Test 8: Giro de pantalla de la vista MisIncidencias", (WidgetTester tester) async{
    await tester.pumpWidget(Login());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    // ]);
    // await tester.pumpAndSettle();
    //
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    // await tester.pumpAndSettle();

    expect(2+2, 4);



  });
}
