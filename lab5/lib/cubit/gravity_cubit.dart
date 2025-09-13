// gravity_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Импортируем библиотеку
import 'dart:convert'; // Для работы с JSON

part 'gravity_state.dart';

class GravityCubit extends Cubit<GravityState> {
  GravityCubit() : super(GravityInitial());

  // Константа для ключа хранения в SharedPreferences
  static const String _calculationsKey = 'calculations';

  void calculateGravity(double mass, double radius) async {
    emit(GravityLoading());

    try {
      const double G = 6.67430e-11;
      final acceleration = G * mass / (radius * radius);

      // Создаем объект с результатами расчета
      final calculation = {
        'mass': mass,
        'radius': radius,
        'acceleration': acceleration,
        'timestamp':
            DateTime.now().toIso8601String(), // Добавляем метку времени
      };

      // Сохраняем расчет
      await _saveCalculation(calculation);

      // Emit-им состояние с результатами
      emit(
        GravityCalculated(
          mass: mass,
          radius: radius,
          acceleration: acceleration,
        ),
      );
    } catch (e) {
      emit(GravityError('Ошибка расчета: $e'));
    }
  }

  // Метод для сохранения расчета в SharedPreferences
  Future<void> _saveCalculation(Map<String, dynamic> calculation) async {
    final prefs = await SharedPreferences.getInstance();

    // Получаем текущий список расчетов
    final List<String> calculationsList =
        prefs.getStringList(_calculationsKey) ?? [];

    // Добавляем новый расчет в формате JSON строки
    calculationsList.add(jsonEncode(calculation));

    // Сохраняем обновленный список обратно
    await prefs.setStringList(_calculationsKey, calculationsList);
  }

  // Метод для загрузки всей истории расчетов (может пригодиться)
  Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> calculationsList =
        prefs.getStringList(_calculationsKey) ?? [];

    // Декодируем каждую JSON строку обратно в Map и возвращаем список
    return calculationsList
        .map((calcJson) => jsonDecode(calcJson) as Map<String, dynamic>)
        .toList();
  }

  void reset() {
    emit(GravityInitial());
  }
}
