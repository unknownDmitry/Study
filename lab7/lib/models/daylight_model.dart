import 'package:hive/hive.dart';

part 'daylight_model.g.dart';

@HiveType(typeId: 1)
class DaylightModel {
  @HiveField(0)
  final String location;

  @HiveField(1)
  final DateTime sunrise;

  @HiveField(2)
  final DateTime sunset;

  @HiveField(3)
  final Duration dayLength;

  @HiveField(4)
  final DateTime date;

  DaylightModel({
    required this.location,
    required this.sunrise,
    required this.sunset,
    required this.dayLength,
    required this.date,
  });
}
