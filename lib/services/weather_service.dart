// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import '../config/api_keys.dart';

class WeatherData {
  final double temperature;
  final int humidity;
  final String description;
  final String icon;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.icon,
  });
}

class WeatherService {
  // DEMO MODE: Returns example weather data
  static Future<WeatherData> getCurrentWeather() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return WeatherData(
      temperature: 22.0,
      humidity: 55,
      description: 'Pochmurno',
      icon: '🌤️',
    );

    /* REAL API IMPLEMENTATION - Uncomment when you have API key
    
    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _getDemoWeather();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _getDemoWeather();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _getDemoWeather();
      }

      Position position = await Geolocator.getCurrentPosition();

      // OpenWeatherMap API call
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?'
          'lat=${position.latitude}&lon=${position.longitude}'
          '&appid=${ApiKeys.weather}&units=metric&lang=pl'
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData(
          temperature: (data['main']['temp'] as num).toDouble(),
          humidity: data['main']['humidity'] as int,
          description: data['weather'][0]['description'] as String,
          icon: _getWeatherIcon(data['weather'][0]['main'] as String),
        );
      }
    } catch (e) {
      // Fallback to demo data on error
    }

    return _getDemoWeather();
    */
  }

  static WeatherData _getDemoWeather() {
    return WeatherData(
      temperature: 22.0,
      humidity: 55,
      description: 'Pochmurno',
      icon: '🌤️',
    );
  }

  static String _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '🌤️';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      default:
        return '🌤️';
    }
  }
}
