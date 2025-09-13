// This is a basic Flutter widget test for the gravity calculator app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab5/main.dart';

void main() {
  testWidgets('Gravity calculator app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed.
    expect(find.text('Савин Д.Н. - Калькулятор ускорения'), findsOneWidget);

    // Verify that input fields are present.
    expect(find.text('Масса небесного тела (кг)'), findsOneWidget);
    expect(find.text('Радиус небесного тела (м)'), findsOneWidget);

    // Verify that the calculate button is present.
    expect(find.text('Рассчитать ускорение'), findsOneWidget);

    // Verify that the history button is present.
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
