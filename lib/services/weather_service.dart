import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../config/api_config.dart';

/// Weather data model
class WeatherData {
  final double temperature;
  final int humidity;
  final String description;
  final String icon;
  final DateTime timestamp;
  final double feelsLike;
  final String condition;
  
  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.timestamp,
    required this.feelsLike,
    required this.condition,
  });
  
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    
    return WeatherData(
      temperature: (main['temp'] as num).toDouble(),
      humidity: main['humidity'] as int,
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      timestamp: DateTime.now(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      condition: weather['main'] as String,
    );
  }
  
  /// Get demo weather data
  factory WeatherData.demo() {
    return WeatherData(
      temperature: 23.0,
      humidity: 55,
      description: 'słonecznie',
      icon: '01d',
      timestamp: DateTime.now(),
      feelsLike: 24.0,
      condition: 'Clear',
    );
  }
  
  String get temperatureString => '${temperature.round()}°C';
  String get humidityString => '$humidity%';
  
  /// Get emoji for weather condition
  String get emoji {
    if (temperature > 28) return '🔥';
    if (temperature < 15) return '❄️';
    if (humidity > 70) return '💧';
    if (humidity < 40) return '🌵';
    return '☀️';
  }
  
  /// Get user-friendly message
  String get message {
    if (temperature > 28) {
      return 'Dzisiaj gorąco - podlej rośliny wcześniej!';
    } else if (temperature < 15) {
      return 'Zimno dzisiaj - rośliny potrzebują mniej wody';
    } else if (humidity > 70) {
      return 'Wysoka wilgotność - możesz podlewać rzadziej';
    } else if (humidity < 40) {
      return 'Suche powietrze - rośliny potrzebują więcej wody';
    }
    return 'Idealne warunki dla roślin! 🌱';
  }
}

/// Weather service for fetching weather data
class WeatherService {
  static WeatherData? _cachedWeather;
  static DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(hours: 1);
  
  /// Get current weather data
  /// Returns cached data if available and fresh (< 1 hour old)
  static Future<WeatherData> getCurrentWeather() async {
    // Check cache
    if (_cachedWeather != null && _lastFetch != null) {
      final age = DateTime.now().difference(_lastFetch!);
      if (age < _cacheDuration) {
        return _cachedWeather!;
      }
    }
    
    // Use demo mode if API key not configured
    if (ApiConfig.useDemoMode || !ApiConfig.isWeatherConfigured) {
      final demoWeather = WeatherData.demo();
      _cachedWeather = demoWeather;
      _lastFetch = DateTime.now();
      return demoWeather;
    }
    
    try {
      // Get current location
      final position = await _getCurrentPosition();
      
      // Fetch weather data
      final url = Uri.parse(
        '${ApiConfig.weatherBaseUrl}/weather?'
        'lat=${position.latitude}&'
        'lon=${position.longitude}&'
        'appid=${ApiConfig.weatherApiKey}&'
        'units=metric&'
        'lang=pl'
      );
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = WeatherData.fromJson(data);
        
        // Update cache
        _cachedWeather = weather;
        _lastFetch = DateTime.now();
        
        return weather;
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      // On error, return demo data
      final demoWeather = WeatherData.demo();
      _cachedWeather = demoWeather;
      _lastFetch = DateTime.now();
      return demoWeather;
    }
  }
  
  /// Get current position with error handling
  static Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Return default location (Warsaw, Poland)
      return Position(
        latitude: 52.2297,
        longitude: 21.0122,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Return default location
        return Position(
          latitude: 52.2297,
          longitude: 21.0122,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Return default location
      return Position(
        latitude: 52.2297,
        longitude: 21.0122,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    
    return await Geolocator.getCurrentPosition();
  }
  
  /// Clear cached weather data
  static void clearCache() {
    _cachedWeather = null;
    _lastFetch = null;
  }
}
