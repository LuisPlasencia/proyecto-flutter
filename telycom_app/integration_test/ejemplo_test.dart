import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:telycom_app/main.dart';
import 'package:telycom_app/misIncidencias.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("failing test example", (WidgetTester tester) async {

  });

  testWidgets("No se ha escrito nombre de usuario, lo que impide el paso de pantalla", (WidgetTester tester) async{
      await tester.pumpWidget(MyApp());
      
      await tester.tap(find.byType(RaisedButton));
      
      await tester.pumpAndSettle();

      // expect(find.byType(FirstRoute), findsWidgets);
      expect(find.byType(MisIncidencias), findsOneWidget);

  });
}
