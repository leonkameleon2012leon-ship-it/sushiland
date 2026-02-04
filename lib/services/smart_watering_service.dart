import '../screens/onboarding/plant_selection_screen.dart';
import 'weather_service.dart';

/// Smart watering service that adjusts watering schedules based on weather
class SmartWateringService {
  /// Calculate adjusted watering days based on weather conditions
  /// 
  /// This method takes the base watering frequency and adjusts it based on:
  /// - Temperature (hot weather = water more often, cold = less often)
  /// - Humidity (dry air = water more often, humid = less often)
  /// - Season (winter = less often, summer = more often)
  static int calculateAdjustedWateringDays(
    Plant plant,
    WeatherData weather,
  ) {
    int baseDays = plant.wateringDays;
    double multiplier = 1.0;
    
    // Temperature adjustments
    // Hot weather (>28°C): water 20% more often
    if (weather.temperature > 28) {
      multiplier *= 0.8; // Reduce days by 20%
    }
    // Warm weather (24-28°C): water 10% more often
    else if (weather.temperature > 24) {
      multiplier *= 0.9; // Reduce days by 10%
    }
    // Cold weather (<18°C): water 20% less often
    else if (weather.temperature < 18) {
      multiplier *= 1.2; // Increase days by 20%
    }
    // Very cold (<15°C): water 30% less often
    else if (weather.temperature < 15) {
      multiplier *= 1.3; // Increase days by 30%
    }
    
    // Humidity adjustments
    // Very dry (<40%): water 10% more often
    if (weather.humidity < 40) {
      multiplier *= 0.9; // Reduce days by 10%
    }
    // Dry (40-50%): water 5% more often
    else if (weather.humidity < 50) {
      multiplier *= 0.95; // Reduce days by 5%
    }
    // Very humid (>70%): water 10% less often
    else if (weather.humidity > 70) {
      multiplier *= 1.1; // Increase days by 10%
    }
    // Extremely humid (>80%): water 15% less often
    else if (weather.humidity > 80) {
      multiplier *= 1.15; // Increase days by 15%
    }
    
    // Season adjustments (based on month)
    final month = DateTime.now().month;
    // Winter (Dec, Jan, Feb): water 30% less often
    if (month == 12 || month == 1 || month == 2) {
      multiplier *= 1.3;
    }
    // Summer (Jun, Jul, Aug): water 10% more often
    else if (month >= 6 && month <= 8) {
      multiplier *= 0.9;
    }
    // Spring/Fall: no adjustment
    
    // Plant-specific adjustments based on type
    switch (plant.plantType) {
      case PlantType.sukulentowa:
        // Succulents need less frequent watering
        multiplier *= 1.1;
        break;
      case PlantType.wiszaca:
        // Hanging plants dry faster
        multiplier *= 0.95;
        break;
      case PlantType.kwitnaca:
        // Flowering plants need consistent moisture
        multiplier *= 0.95;
        break;
      case PlantType.doniczkowa:
        // No adjustment for potted plants
        break;
    }
    
    // Light requirement adjustments
    switch (plant.lightRequirement) {
      case LightRequirement.pelneSlonce:
        // Full sun plants dry faster
        multiplier *= 0.9;
        break;
      case LightRequirement.cien:
        // Shade plants need less water
        multiplier *= 1.1;
        break;
      case LightRequirement.polcien:
        // No adjustment for partial shade
        break;
    }
    
    // Calculate final adjusted days
    final adjustedDays = (baseDays * multiplier).round();
    
    // Ensure reasonable bounds (minimum 1 day, maximum 30 days)
    return adjustedDays.clamp(1, 30);
  }
  
  /// Get a user-friendly explanation of the adjustment
  static String getAdjustmentExplanation(
    Plant plant,
    WeatherData weather,
  ) {
    final baseDays = plant.wateringDays;
    final adjustedDays = calculateAdjustedWateringDays(plant, weather);
    
    if (adjustedDays == baseDays) {
      return 'Standardowy harmonogram podlewania';
    } else if (adjustedDays < baseDays) {
      final difference = baseDays - adjustedDays;
      return 'Podlewaj $difference dni wcześniej z powodu ${_getMainReason(weather)}';
    } else {
      final difference = adjustedDays - baseDays;
      return 'Możesz podlewać $difference dni później z powodu ${_getMainReason(weather)}';
    }
  }
  
  /// Get the main reason for adjustment
  static String _getMainReason(WeatherData weather) {
    if (weather.temperature > 28) {
      return 'wysokiej temperatury';
    } else if (weather.temperature < 15) {
      return 'niskiej temperatury';
    } else if (weather.humidity < 40) {
      return 'niskiej wilgotności';
    } else if (weather.humidity > 70) {
      return 'wysokiej wilgotności';
    }
    
    final month = DateTime.now().month;
    if (month == 12 || month == 1 || month == 2) {
      return 'zimy';
    } else if (month >= 6 && month <= 8) {
      return 'lata';
    }
    
    return 'warunków pogodowych';
  }
  
  /// Check if watering is recommended today based on weather
  static bool shouldWaterToday(
    Plant plant,
    DateTime lastWatered,
    WeatherData weather,
  ) {
    final adjustedDays = calculateAdjustedWateringDays(plant, weather);
    final daysSinceWatered = DateTime.now().difference(lastWatered).inDays;
    
    return daysSinceWatered >= adjustedDays;
  }
  
  /// Get next recommended watering date
  static DateTime getNextWateringDate(
    Plant plant,
    DateTime lastWatered,
    WeatherData weather,
  ) {
    final adjustedDays = calculateAdjustedWateringDays(plant, weather);
    return lastWatered.add(Duration(days: adjustedDays));
  }
}
