/// Helper utilities for the plant care application

/// Returns the correct Polish pluralization for years based on the age.
/// 
/// Examples:
/// - 1 rok
/// - 2-4 lata
/// - 5+ lat
String getAgePluralization(int age) {
  if (age == 1) {
    return 'rok';
  } else if (age < 5) {
    return 'lata';
  } else {
    return 'lat';
  }
}

/// Trims the watering history to keep only the most recent entries.
/// 
/// Returns a new list with at most [maxCount] recent entries.
List<DateTime> trimWateringHistory(List<DateTime> history, int maxCount) {
  if (history.length <= maxCount) {
    return history;
  }
  return history.sublist(history.length - maxCount);
}
