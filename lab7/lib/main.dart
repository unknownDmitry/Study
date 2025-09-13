import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/weather_model.dart';
import 'models/daylight_model.dart';
import 'models/duration_adapter.dart';

import 'api/weather_api.dart';
import 'cubit/weather_cubit.dart';
import 'cubit/daylight_cubit.dart';

import 'screens/weather_screen.dart';
import 'screens/developer_screen.dart';
import 'screens/daylight_calculator_screen.dart';
import 'screens/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive асинхронно, чтобы не блокировать UI
  await _initializeHive();

  runApp(const WeatherApp());
}

Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();

    // Регистрируем адаптеры только если они еще не зарегистрированы
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WeatherModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DaylightModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(DurationAdapter());
    }

    // Открываем базы данных параллельно для ускорения
    await Future.wait([
      Hive.openBox<WeatherModel>('weather_history'),
      Hive.openBox<DaylightModel>('daylight_history'),
    ]);
  } catch (e) {
    // Логируем ошибку, но не останавливаем приложение
    debugPrint('Ошибка инициализации Hive: $e');
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherCubit(OpenWeatherMapApi())..loadHistory(),
        ),
        BlocProvider(create: (context) => DaylightCubit()..loadHistory()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
        routes: {
          '/weather': (context) => const WeatherPage(),
          '/developer': (context) => const DeveloperPage(),
          '/daylight': (context) => const DaylightCalculatorPage(),
          '/camera': (context) => const CameraPage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    // Ждем 2 секунды, чтобы показать экран загрузки
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Weather App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
