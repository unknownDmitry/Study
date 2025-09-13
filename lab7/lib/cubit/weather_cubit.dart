import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../api/weather_api.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApi weatherApi;
  late final Box<WeatherModel> historyBox;

  WeatherCubit(this.weatherApi) : super(WeatherInitial()) {
    try {
      if (Hive.isBoxOpen('weather_history')) {
        historyBox = Hive.box<WeatherModel>('weather_history');
      } else {
        // Если бокс не открыт, открываем его
        Hive.openBox<WeatherModel>('weather_history').then((box) {
          historyBox = box;
        });
      }
    } catch (e) {
      // Если Hive не инициализирован, создаем пустой список
      debugPrint('Hive не инициализирован: $e');
    }
  }

  Future<void> getWeather(String city) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherApi.getWeather(city);
      if (Hive.isBoxOpen('weather_history')) {
        await historyBox.add(weather);
      }
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> loadHistory() async {
    emit(WeatherHistoryLoading());
    try {
      if (Hive.isBoxOpen('weather_history')) {
        final history = historyBox.values.toList().reversed.toList();
        emit(WeatherHistoryLoaded(history));
      } else {
        emit(WeatherHistoryLoaded([]));
      }
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  // Метод для расчета точки росы
  double calculateDewPoint({
    required double temperature,
    required double humidity,
  }) {
    // Формула Магнуса для расчета точки росы
    final a = 17.27;
    final b = 237.7;

    final alpha =
        ((a * temperature) / (b + temperature)) +
        (log(humidity / 100.0) / log(10.0));

    return (b * alpha) / (a - alpha);
  }

  // Метод для сохранения расчета точки росы
  Future<void> saveDewPointCalculation({
    required double temperature,
    required double humidity,
    required String city,
  }) async {
    try {
      final dewPoint = calculateDewPoint(
        temperature: temperature,
        humidity: humidity,
      );

      final weatherModel = WeatherModel(
        city: city,
        temperature: temperature,
        description: 'Ручной расчет',
        date: DateTime.now(),
        humidity: humidity,
        dewPoint: dewPoint,
        timestamp: DateTime.now(),
      );

      if (Hive.isBoxOpen('weather_history')) {
        await historyBox.add(weatherModel);
      }
    } catch (e) {
      emit(WeatherError('Ошибка сохранения: $e'));
    }
  }

  @override
  Future<void> close() {
    if (Hive.isBoxOpen('weather_history')) {
      historyBox.close();
    }
    return super.close();
  }
}

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherHistoryLoading extends WeatherState {}

class WeatherHistoryLoaded extends WeatherState {
  final List<WeatherModel> history;

  const WeatherHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
