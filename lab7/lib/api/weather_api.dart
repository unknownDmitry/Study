import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';


abstract class WeatherApi {
  Future<WeatherModel> getWeather(String city);
}

class OpenWeatherMapApi implements WeatherApi {
  
  final String apiKey = '03523f0c0f11c8e9cca3266fe83bf6c5';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  @override
  Future<WeatherModel> getWeather(String city) async {
    try {
  
      final uri = Uri.parse(
          '$baseUrl?q=${Uri.encodeComponent(city)}&appid=$apiKey&units=metric');
    
      final response = await http.get(uri);
   
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final int? cod = data['cod'];
        if (cod != 200) {
          throw Exception(data['message'] ?? 'Unknown error from API');
        }

        return WeatherModel(
          city: city,
          temperature: data['main']['temp'].toDouble(),
          description: data['weather'][0]['description'],
          date: DateTime.now(),
        );
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}