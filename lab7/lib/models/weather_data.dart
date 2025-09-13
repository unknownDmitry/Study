class WeatherData {
  final String city;
  final double temperature;
  final double humidity;
  final double dewPoint;
  final String? photoPath;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.dewPoint,
    this.photoPath,
  });

  WeatherData copyWith({
    String? city,
    double? temperature,
    double? humidity,
    double? dewPoint,
    String? photoPath,
  }) {
    return WeatherData(
      city: city ?? this.city,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      dewPoint: dewPoint ?? this.dewPoint,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  String toString() {
    return 'WeatherData(city: $city, temperature: $temperature, humidity: $humidity, dewPoint: $dewPoint, photoPath: $photoPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherData &&
        other.city == city &&
        other.temperature == temperature &&
        other.humidity == humidity &&
        other.dewPoint == dewPoint &&
        other.photoPath == photoPath;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        temperature.hashCode ^
        humidity.hashCode ^
        dewPoint.hashCode ^
        photoPath.hashCode;
  }
}
