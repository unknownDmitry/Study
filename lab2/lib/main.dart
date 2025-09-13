import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Савин Дмитрий Николаевич')),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Левый верхний угол
        Positioned(
          top: 20,
          left: 20,
          child: Container(width: 100, height: 100, color: Colors.red),
        ),

        // Правый верхний угол
        Positioned(
          top: 20,
          right: 20,
          child: Container(width: 120, height: 80, color: Colors.orange),
        ),

        // Левый нижний угол
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(width: 90, height: 110, color: Colors.yellow),
        ),

        // Правый нижний угол
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(width: 130, height: 70, color: Colors.green),
        ),

        // Центр
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: Container(width: 100, height: 100, color: Colors.blue),
        ),
      ],
    );
  }
}
