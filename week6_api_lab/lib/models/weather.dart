class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List<dynamic>;
    if (weatherList.isEmpty) {
      throw const FormatException('weather list is empty');
    }
    final weather = weatherList.first as Map<String, dynamic>;
    return Weather(
      cityName: json['name'] as String,
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'] as String,
      feelsLike: (main['feels_like'] as num).toDouble(),
    );
  }
}

