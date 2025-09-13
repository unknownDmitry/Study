import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab6/screen/cubit/nasa_cubit.dart';
import 'package:lab6/screen/nasa_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA Mars Photos App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<NasaCubit>(
        create: (context) => NasaCubit(),
        child: const NasaScreen(),
      ),
    );
  }
}
