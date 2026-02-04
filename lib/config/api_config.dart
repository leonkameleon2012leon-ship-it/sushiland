/// API Configuration for external services
class ApiConfig {
  // Plant.id API (Free tier available at https://plant.id/)
  // Get your free API key at: https://web.plant.id/api-access/
  static const String plantIdApiKey = 'YOUR_PLANT_ID_API_KEY_HERE';
  static const String plantIdBaseUrl = 'https://api.plant.id/v2';
  
  // OpenWeatherMap API (Free tier available at https://openweathermap.org/api)
  // Get your free API key at: https://home.openweathermap.org/api_keys
  static const String weatherApiKey = 'YOUR_OPENWEATHER_API_KEY_HERE';
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Demo mode settings
  static const bool useDemoMode = true; // Set to false when you have real API keys
  
  // Check if API keys are configured
  static bool get isPlantIdConfigured => 
      plantIdApiKey != 'YOUR_PLANT_ID_API_KEY_HERE' && plantIdApiKey.isNotEmpty;
  
  static bool get isWeatherConfigured => 
      weatherApiKey != 'YOUR_OPENWEATHER_API_KEY_HERE' && weatherApiKey.isNotEmpty;
}
