// history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/history_cubit.dart';
import 'package:intl/intl.dart'; // Добавьте этот импорт

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История расчетов')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial || state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          } else if (state is HistoryLoaded) {
            final calculations = state.calculations;
            if (calculations.isEmpty) {
              return const Center(child: Text('История расчетов пуста.'));
            }
            return ListView.builder(
              itemCount: calculations.length,
              itemBuilder: (context, index) {
                final calc = calculations[index];
                return ListTile(
                  title: Text(
                    'g = ${(calc['acceleration'] as double).toStringAsFixed(8)} м/с²',
                  ),
                  subtitle: Text(
                    'Масса: ${calc['mass']} кг, Радиус: ${calc['radius']} м',
                  ),
                  trailing: Text(
                    DateFormat(
                      'dd.MM.yyyy HH:mm',
                    ).format(DateTime.parse(calc['timestamp'])),
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
