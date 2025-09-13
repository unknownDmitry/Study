import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double mass;
  final double radius;

  const ResultScreen({super.key, required this.mass, required this.radius});

  double calculateGravityAcceleration() {
    const double G = 6.67430e-11; // Гравитационная постоянная (м³ кг⁻¹ с⁻²)
    // Формула: g = G * M / r²
    return G * mass / (radius * radius);
  }

  @override
  Widget build(BuildContext context) {
    final acceleration = calculateGravityAcceleration();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат расчета'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ускорение свободного падения:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '${acceleration.toStringAsFixed(6)} м/с²',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Масса: ${mass.toStringAsFixed(2)} кг\n'
                'Радиус: ${radius.toStringAsFixed(2)} м',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Назад к расчету'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
