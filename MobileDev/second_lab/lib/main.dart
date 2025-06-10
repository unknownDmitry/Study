import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Лабораторная работа")),
        body: MyHomePage(),
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
        Align(
          alignment: Alignment.topLeft,
          child: Container(color: Colors.red, width: 100, height: 100),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(color: Colors.green, width: 80, height: 80),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(color: Colors.blue, width: 60, height: 60),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(color: Colors.orange, width: 40, height: 40),
        ),
      ],
    );
  }
}
