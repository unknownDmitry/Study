import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/daylight_model.dart';

class DaylightCubit extends Cubit<DaylightState> {
  late final Box<DaylightModel> historyBox;

  DaylightCubit() : super(DaylightInitial()) {
    try {
      if (Hive.isBoxOpen('daylight_history')) {
        historyBox = Hive.box<DaylightModel>('daylight_history');
      } else {
        // Если бокс не открыт, открываем его
        Hive.openBox<DaylightModel>('daylight_history').then((box) {
          historyBox = box;
        });
      }
    } catch (e) {
      // Если Hive не инициализирован, создаем пустой список
      debugPrint('Hive не инициализирован: $e');
    }
  }

  Future<void> calculateDaylight(String location, DateTime date) async {
    emit(DaylightLoading());
    try {
      final coords = location.split(',');
      if (coords.length != 2) {
        throw Exception('Enter coordinates as "latitude,longitude"');
      }

      final response = await http.get(
        Uri.parse(
          'https://api.sunrisesunset.io/json?'
          'lat=${coords[0]}&lng=${coords[1]}&date=${DateFormat('yyyy-MM-dd').format(date)}&formatted=0',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final sunrise = parseTime(data['results']['sunrise'], date);

          final sunset = parseTime(
            data['results']['sunset'],
            date,
          ).add(const Duration(hours: 12));

          final dayLength = sunset.difference(sunrise).abs();

          final daylight = DaylightModel(
            location: location,
            sunrise: sunrise,
            sunset: sunset,
            dayLength: dayLength,
            date: date,
          );

          if (Hive.isBoxOpen('daylight_history')) {
            await historyBox.add(daylight);
          }
          emit(DaylightLoaded(daylight));
        }
      }
    } catch (e) {
      emit(DaylightError('Error: ${e.toString()}'));
    }
  }

  DateTime parseTime(String timeStr, DateTime date) {
    final timeParts = timeStr.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  Future<void> loadHistory() async {
    emit(DaylightHistoryLoading());
    try {
      if (Hive.isBoxOpen('daylight_history')) {
        final history = historyBox.values.toList().reversed.toList();
        emit(DaylightHistoryLoaded(history));
      } else {
        emit(DaylightHistoryLoaded([]));
      }
    } catch (e) {
      emit(DaylightError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    if (Hive.isBoxOpen('daylight_history')) {
      historyBox.close();
    }
    return super.close();
  }
}

abstract class DaylightState extends Equatable {
  const DaylightState();

  @override
  List<Object> get props => [];
}

class DaylightInitial extends DaylightState {}

class DaylightLoading extends DaylightState {}

class DaylightLoaded extends DaylightState {
  final DaylightModel daylight;

  const DaylightLoaded(this.daylight);

  @override
  List<Object> get props => [daylight];
}

class DaylightHistoryLoading extends DaylightState {}

class DaylightHistoryLoaded extends DaylightState {
  final List<DaylightModel> history;

  const DaylightHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class DaylightError extends DaylightState {
  final String message;

  const DaylightError(this.message);

  @override
  List<Object> get props => [message];
}
