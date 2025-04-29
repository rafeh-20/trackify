// lib/models/habit.dart
enum DayStatus { empty, positive, negative }

class Habit {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  Map<DateTime, DayStatus> dayStatuses; // Tracks the status of each day
  int streakCount;
  int totalDays;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    this.dayStatuses = const {},
    this.streakCount = 0,
    this.totalDays = 0,
  });

  double get successRate {
    final positiveDays = dayStatuses.values.where((status) => status == DayStatus.positive).length;
    return totalDays == 0 ? 0 : (positiveDays / totalDays) * 100;
  }

  void toggleDayStatus(DateTime date) {
    dayStatuses[date] = dayStatuses[date] == DayStatus.positive
        ? DayStatus.negative
        : dayStatuses[date] == DayStatus.negative
            ? DayStatus.empty
            : DayStatus.positive;
    updateStreak();
  }

  void updateStreak() {
    streakCount = 0;
    final sortedDates = dayStatuses.keys.toList()..sort();
    int currentStreak = 0;

    for (int i = 0; i < sortedDates.length; i++) {
      if (dayStatuses[sortedDates[i]] == DayStatus.positive) {
        currentStreak++;
        streakCount = currentStreak > streakCount ? currentStreak : streakCount;
      } else {
        currentStreak = 0;
      }
    }
  }
}