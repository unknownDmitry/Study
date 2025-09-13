import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_data.dart';

class WeatherService {
  // Ключ не прячу, достался бесплатно
  static const String _apiKey = 'feef1d65a9cd4fe7ac00b2809b604eaa';
  static const String _baseUrl = 'https://api.weatherbit.io/v2.0/current';

  Future<WeatherData> getWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?city=$city&key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final weather = data['data'][0];
          return WeatherData(
            city: city,
            temperature: weather['temp']?.toDouble() ?? 0.0,
            humidity: weather['rh']?.toDouble() ?? 0.0,
            dewPoint: 0.0, // Рассчитывается в Cubit
          );
        } else {
          throw Exception('No weather data found for city: $city');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 404) {
        throw Exception('City not found: $city');
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from weather API');
      } else if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Network error: $e');
      }
    }
  }
}
