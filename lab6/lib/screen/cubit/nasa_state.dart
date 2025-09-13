import 'package:lab6/models/nasa.dart';

abstract class NasaState {}

class NasaLoadingState extends NasaState {}

class NasaLoadedState extends NasaState {
  Nasa data;
  NasaLoadedState({required this.data});
}

class NasaErrorState extends NasaState {}
