enum DayStatus { empty, positive, negative }

class Habit {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  Map<DateTime, DayStatus> dayStatuses;
  int streakCount;
  int totalDays;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    Map<DateTime, DayStatus>? dayStatuses,
    this.streakCount = 0,
    this.totalDays = 0,
  }) : dayStatuses = dayStatuses ?? {};

  double get successRate {
  final totalTrackedDays = DateTime.now().difference(startDate).inDays + 1;
  final positiveDays = dayStatuses.values.where((status) => status == DayStatus.positive).length;
  return totalTrackedDays == 0 ? 0 : (positiveDays / totalTrackedDays) * 100;
}

  void toggleDayStatus(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final currentStatus = dayStatuses[dateOnly] ?? DayStatus.empty;

    dayStatuses[dateOnly] = currentStatus == DayStatus.positive
        ? DayStatus.negative
        : currentStatus == DayStatus.negative
            ? DayStatus.empty
            : DayStatus.positive;

    if (dayStatuses[dateOnly] == DayStatus.negative) {
      updateStreak(reset: true);
    } else {
      updateStreak(reset: false);
    }
  }

  void updateStreak({bool reset = false}) {
    if (reset) {
      streakCount = 0;
      return;
    }

    streakCount = 0;
    final sortedDates = dayStatuses.keys.toList()..sort();
    int currentStreak = 0;

    for (int i = 0; i < sortedDates.length; i++) {
      final status = dayStatuses[sortedDates[i]] ?? DayStatus.negative;
      if (status == DayStatus.positive) {
        currentStreak++;
        streakCount = currentStreak > streakCount ? currentStreak : streakCount;
      } else if (status == DayStatus.negative) {
        currentStreak = 0;
      }
    }
  }
}