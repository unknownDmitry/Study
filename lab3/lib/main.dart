import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор ускорения свободного падения',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputScreen(),
    );
  }
}
