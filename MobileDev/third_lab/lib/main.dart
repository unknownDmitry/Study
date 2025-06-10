import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор ускорения',
      home: GravityInputScreen(),
    );
  }
}

class GravityInputScreen extends StatefulWidget {
  @override
  _GravityInputScreenState createState() => _GravityInputScreenState();
}

class _GravityInputScreenState extends State<GravityInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _massController = TextEditingController();
  final _radiusController = TextEditingController();
  bool _agreed = false;
  bool _checkboxError = false;

  @override
  void dispose() {
    _massController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _checkboxError = !_agreed;
    });

    if (_formKey.currentState!.validate() && _agreed) {
      final double mass = double.parse(
        _massController.text.replaceAll(',', '.'),
      );
      final double radius = double.parse(
        _radiusController.text.replaceAll(',', '.'),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GravityResultScreen(mass: mass, radius: radius),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ФИО: Савин Дмитрий Николаевич')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _massController,
                decoration: InputDecoration(
                  labelText: 'Масса небесного тела (кг)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите массу';
                  final num? v = num.tryParse(value.replaceAll(',', '.'));
                  if (v == null || v <= 0) return 'Введите положительное число';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _radiusController,
                decoration: InputDecoration(
                  labelText: 'Радиус небесного тела (м)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите радиус';
                  final num? v = num.tryParse(value.replaceAll(',', '.'));
                  if (v == null || v <= 0) return 'Введите положительное число';
                  return null;
                },
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Согласие на обработку данных'),
                value: _agreed,
                onChanged: (bool? value) {
                  setState(() {
                    _agreed = value ?? false;
                    if (_agreed) _checkboxError = false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (_checkboxError)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Требуется согласие',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: Text('Рассчитать')),
            ],
          ),
        ),
      ),
    );
  }
}

class GravityResultScreen extends StatelessWidget {
  final double mass;
  final double radius;

  GravityResultScreen({required this.mass, required this.radius});

  @override
  Widget build(BuildContext context) {
    // Формула: g = G * M / R^2
    const double G = 6.67430e-11;
    double g = G * mass / (radius * radius);

    return Scaffold(
      appBar: AppBar(title: Text('Результат')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ускорение свободного падения:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              '${g.toStringAsFixed(5)} м/с²',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
