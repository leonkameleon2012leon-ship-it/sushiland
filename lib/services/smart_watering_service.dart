import '../models/plant.dart';
import 'weather_service.dart';

class SmartWateringService {
  /// Calculates adjusted watering days based on weather conditions
  static int calculateAdjustedWateringDays(Plant plant, WeatherData weather) {
    double baseDays = plant.wateringDays.toDouble();
    double adjustment = 1.0;

    // Temperature adjustments
    if (weather.temperature > 28) {
      adjustment *= 0.75; // -25% for hot weather
    } else if (weather.temperature < 15) {
      adjustment *= 1.30; // +30% for cold weather
    }

    // Humidity adjustments
    if (weather.humidity < 30) {
      adjustment *= 0.85; // -15% for dry air
    } else if (weather.humidity > 70) {
      adjustment *= 1.15; // +15% for humid air
    }

    // Seasonal adjustments
    final month = DateTime.now().month;
    if (month >= 12 || month <= 2) {
      // Winter (December - February)
      adjustment *= 1.20; // +20% for winter
    } else if (month >= 6 && month <= 8) {
      // Summer (June - August)
      adjustment *= 0.90; // -10% for summer
    }

    final adjustedDays = (baseDays * adjustment).round();
    return adjustedDays.clamp(1, 30);
  }

  /// Provides watering advice based on current weather
  static String getWateringAdvice(WeatherData weather) {
    if (weather.temperature > 28) {
      return 'Bardzo gorąco! Podlej wcześniej ☀️';
    } else if (weather.temperature < 10) {
      return 'Zimno - rośliny potrzebują mniej wody ❄️';
    } else if (weather.humidity < 30) {
      return 'Suche powietrze - zwiększ podlewanie 🏜️';
    } else if (weather.humidity > 70) {
      return 'Wysoka wilgotność - podlewaj rzadziej 💧';
    } else if (_isIdealConditions(weather)) {
      return 'Idealne warunki dla roślin! 🌱';
    } else {
      return 'Dobre warunki dla roślin 🌿';
    }
  }

  /// Checks if conditions are ideal for plants
  static bool _isIdealConditions(WeatherData weather) {
    return weather.temperature >= 20 && 
           weather.temperature <= 25 && 
           weather.humidity >= 40 && 
           weather.humidity <= 60;
  }

  /// Returns weather emoji icon based on conditions
  static String getWeatherIcon(WeatherData weather) {
    if (weather.temperature > 30) {
      return '🌞';
    } else if (weather.temperature > 25) {
      return '☀️';
    } else if (weather.temperature < 5) {
      return '❄️';
    } else if (weather.humidity > 80) {
      return '💧';
    } else if (weather.humidity < 30) {
      return '🏜️';
    } else {
      return weather.icon;
    }
  }
}
