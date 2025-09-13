import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel {
  @HiveField(0)
  final String city;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final double? humidity;

  @HiveField(5)
  final double? dewPoint;

  @HiveField(6)
  final DateTime? timestamp;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.description,
    required this.date,
    this.humidity,
    this.dewPoint,
    this.timestamp,
  });
}
