// history_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  // Константа для ключа должна совпадать с той, что в GravityCubit
  static const String _calculationsKey = 'calculations';

  // Метод для загрузки истории расчетов
  void loadHistory() async {
    emit(HistoryLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> calculationsList =
          prefs.getStringList(_calculationsKey) ?? [];

      // Декодируем каждую запись
      List<Map<String, dynamic>> history =
          calculationsList
              .map((calcJson) => jsonDecode(calcJson) as Map<String, dynamic>)
              .toList();

      // Сортируем по дате (от новых к старым)
      history.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError('Не удалось загрузить историю: $e'));
    }
  }
}
