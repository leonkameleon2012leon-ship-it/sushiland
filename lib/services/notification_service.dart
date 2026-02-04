import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../screens/onboarding/plant_selection_screen.dart';

/// Service for managing local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  static bool _notificationsEnabled = true;
  
  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize timezone data
    tz.initializeTimeZones();
    
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    // Combined initialization settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // Initialize plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _initialized = true;
  }
  
  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can navigate to specific screen
    // For now, just log it
    print('Notification tapped: ${response.payload}');
  }
  
  /// Request notification permissions (iOS)
  static Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();
    
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    return result ?? true;
  }
  
  /// Schedule a watering reminder notification
  static Future<void> scheduleWateringReminder(
    Plant plant,
    DateTime scheduledDate,
    int id,
  ) async {
    if (!_initialized) await initialize();
    if (!_notificationsEnabled) return;
    
    try {
      // Schedule at 9 AM on the scheduled date
      final scheduledDateTime = tz.TZ(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        9, // 9 AM
        0,
        0,
      );
      
      await _notifications.zonedSchedule(
        id,
        'Czas podlać ${plant.name}! 💧',
        'Twoja ${plant.name} czeka na wodę 🌱',
        scheduledDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'watering_reminders',
            'Przypomnienia o podlewaniu',
            channelDescription: 'Powiadomienia o czasie podlewania roślin',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'watering_${plant.name}',
      );
    } catch (e) {
      print('Error scheduling watering reminder: $e');
    }
  }
  
  /// Send immediate weather alert
  static Future<void> sendWeatherAlert(String message) async {
    if (!_initialized) await initialize();
    if (!_notificationsEnabled) return;
    
    try {
      await _notifications.show(
        999, // Special ID for weather alerts
        'Uwaga! Zmiana pogody ☀️',
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_alerts',
            'Alerty pogodowe',
            channelDescription: 'Powiadomienia o zmianie pogody wpływającej na rośliny',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'weather_alert',
      );
    } catch (e) {
      print('Error sending weather alert: $e');
    }
  }
  
  /// Send health warning for a plant
  static Future<void> sendHealthWarning(Plant plant, String issue) async {
    if (!_initialized) await initialize();
    if (!_notificationsEnabled) return;
    
    try {
      await _notifications.show(
        plant.name.hashCode, // Use plant name hash as ID
        'Uwaga! Problem z ${plant.name} 🍂',
        issue,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'health_warnings',
            'Ostrzeżenia zdrowotne',
            channelDescription: 'Powiadomienia o problemach zdrowotnych roślin',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'health_${plant.name}',
      );
    } catch (e) {
      print('Error sending health warning: $e');
    }
  }
  
  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    if (!_initialized) await initialize();
    
    await _notifications.cancel(id);
  }
  
  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    if (!_initialized) await initialize();
    
    await _notifications.cancelAll();
  }
  
  /// Enable or disable notifications
  static void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
  }
  
  /// Check if notifications are enabled
  static bool get notificationsEnabled => _notificationsEnabled;
}
