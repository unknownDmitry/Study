import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class StorageService {
  static const String _weatherKey = 'weather_history';
  static const String _dewPointKey = 'dew_point_history';

  Future<void> saveWeather(WeatherData weather) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> weatherList = prefs.getStringList(_weatherKey) ?? [];

    // Добавляем новую запись
    weatherList.add(jsonEncode({
      'city': weather.city,
      'temperature': weather.temperature,
      'humidity': weather.humidity,
      'dewPoint': weather.dewPoint,
      'photoPath': weather.photoPath,
      'timestamp': DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(_weatherKey, weatherList);
  }

  Future<void> saveDewPoint(WeatherData weather) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dewPointList = prefs.getStringList(_dewPointKey) ?? [];

    // Добавляем новую запись
    dewPointList.add(jsonEncode({
      'city': weather.city,
      'temperature': weather.temperature,
      'humidity': weather.humidity,
      'dewPoint': weather.dewPoint,
      'photoPath': weather.photoPath,
      'timestamp': DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(_dewPointKey, dewPointList);
  }

  Future<List<WeatherData>> getWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> weatherList = prefs.getStringList(_weatherKey) ?? [];

    return weatherList.map((jsonString) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return WeatherData(
        city: data['city'],
        temperature: data['temperature'].toDouble(),
        humidity: data['humidity'].toDouble(),
        dewPoint: data['dewPoint'].toDouble(),
        photoPath: data['photoPath'],
      );
    }).toList();
  }

  Future<List<WeatherData>> getDewPointHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dewPointList = prefs.getStringList(_dewPointKey) ?? [];

    return dewPointList.map((jsonString) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return WeatherData(
        city: data['city'],
        temperature: data['temperature'].toDouble(),
        humidity: data['humidity'].toDouble(),
        dewPoint: data['dewPoint'].toDouble(),
        photoPath: data['photoPath'],
      );
    }).toList();
  }

  Future<void> clearWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
  }

  Future<void> clearDewPointHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dewPointKey);
  }
}
