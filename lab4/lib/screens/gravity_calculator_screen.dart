import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/gravity_cubit.dart';

class GravityCalculatorScreen extends StatefulWidget {
  const GravityCalculatorScreen({super.key});

  @override
  State<GravityCalculatorScreen> createState() =>
      _GravityCalculatorScreenState();
}

class _GravityCalculatorScreenState extends State<GravityCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _massController = TextEditingController();
  final _radiusController = TextEditingController();
  bool _isAgreed = false;

  @override
  void dispose() {
    _massController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _calculateGravity() {
    if (_formKey.currentState!.validate() && _isAgreed) {
      final mass = double.parse(_massController.text);
      final radius = double.parse(_radiusController.text);

      context.read<GravityCubit>().calculateGravity(mass, radius);
    } else if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, согласитесь на обработку данных'),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _massController.clear();
    _radiusController.clear();
    setState(() {
      _isAgreed = false;
    });
    context.read<GravityCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Савин Д.Н. - Калькулятор ускорения'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GravityCubit, GravityState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Поля ввода
                  if (state is GravityInitial || state is GravityError)
                    _buildInputFields(),

                  // Состояние загрузки
                  if (state is GravityLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Выполняется расчет...'),
                          ],
                        ),
                      ),
                    ),

                  // Результат расчета
                  if (state is GravityCalculated) _buildResult(state),

                  // Ошибка
                  if (state is GravityError) _buildError(state),

                  // Кнопки действий
                  const SizedBox(height: 24),
                  _buildActionButtons(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextFormField(
          controller: _massController,
          decoration: const InputDecoration(
            labelText: 'Масса небесного тела (кг)',
            border: OutlineInputBorder(),
            hintText: 'Введите массу',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите массу';
            }
            final numValue = double.tryParse(value);
            if (numValue == null || numValue <= 0) {
              return 'Введите положительное число';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _radiusController,
          decoration: const InputDecoration(
            labelText: 'Радиус небесного тела (м)',
            border: OutlineInputBorder(),
            hintText: 'Введите радиус',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите радиус';
            }
            final numValue = double.tryParse(value);
            if (numValue == null || numValue <= 0) {
              return 'Введите положительное число';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Согласие на обработку данных'),
          value: _isAgreed,
          onChanged: (value) {
            setState(() {
              _isAgreed = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildResult(GravityCalculated state) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Результат расчета:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${state.acceleration.toStringAsFixed(8)} м/с²',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Масса: ${state.mass.toStringAsFixed(2)} кг\n'
              'Радиус: ${state.radius.toStringAsFixed(2)} м',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(GravityError state) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(GravityState state) {
    return Column(
      children: [
        // Показываем кнопку "Рассчитать" ТОЛЬКО на экранах ввода (Initial и Error)
        if (state is GravityInitial || state is GravityError)
          ElevatedButton(
            onPressed: _calculateGravity,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Рассчитать ускорение'),
          ),

        // Добавляем отступ, если следующая кнопка будет показана
        if (state is GravityCalculated || state is GravityError)
          const SizedBox(height: 16),

        // Показываем кнопку "Новый расчет" после получения Результата или Ошибки
        if (state is GravityCalculated || state is GravityError)
          OutlinedButton(
            onPressed: _resetForm,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Новый расчет'),
          ),
      ],
    );
  }
}
