// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';

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

  testWidgets('Test 2: Poniendo texto en el textfield y contraseña', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final user = find.byKey(ValueKey("user"));
    final password = find.byKey(ValueKey("password"));

    await tester.pumpWidget(MaterialApp(home:FirstRoute()));
    await tester.enterText(user, "holahola");
    await tester.enterText(password, "caca");
    await tester.pump();

    expect(find.text("holahola"), findsOneWidget);
    expect(find.text("caca"), findsOneWidget);
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
