import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/weather_cubit.dart';
import '../models/weather_data.dart';
import '../services/storage_service.dart';

class DewPointScreen extends StatelessWidget {
  const DewPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tempController = TextEditingController();
    final TextEditingController humidityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Калькулятор точки росы')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Температура (°C)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: humidityController,
              decoration: const InputDecoration(
                labelText: 'Влажность (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final temperature = double.tryParse(tempController.text);
                final humidity = double.tryParse(humidityController.text);
                if (temperature != null && humidity != null) {
                  BlocProvider.of<WeatherCubit>(
                    context,
                  ).saveDewPointCalculation(
                    temperature: temperature,
                    humidity: humidity,
                    city: 'Ручной ввод',
                  );

                  // Показываем результат
                  final dewPoint =
                      BlocProvider.of<WeatherCubit>(context).calculateDewPoint(
                    temperature: temperature,
                    humidity: humidity,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Точка росы: ${dewPoint.toStringAsFixed(1)}°C'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пожалуйста, введите корректные значения'),
                    ),
                  );
                }
              },
              child: const Text('Рассчитать точку росы'),
            ),
            const SizedBox(height: 20),
            const Text('История расчетов', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<WeatherData>>(
                future: StorageService().getDewPointHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  }

                  final history = snapshot.data ?? [];
                  if (history.isEmpty) {
                    return const Center(
                      child: Text('История расчетов пуста'),
                    );
                  }

                  // Ограничиваем количество отображаемых элементов для производительности
                  final limitedHistory = history.take(50).toList();

                  return ListView.builder(
                    itemCount: limitedHistory.length,
                    // Добавляем кэширование для улучшения производительности
                    cacheExtent: 200,
                    itemBuilder: (context, index) {
                      final weather = limitedHistory[limitedHistory.length -
                          1 -
                          index]; // Показываем новые записи первыми
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(weather.city),
                          subtitle: Text(
                            'Температура: ${weather.temperature.toStringAsFixed(1)}°C\n'
                            'Влажность: ${weather.humidity.toStringAsFixed(1)}%\n'
                            'Точка росы: ${weather.dewPoint.toStringAsFixed(1)}°C',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
