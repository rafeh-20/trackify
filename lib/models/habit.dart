enum DayStatus { empty, positive, negative }

class Habit {
  String id; // Firestore document ID
  final String name;
  final String description;
  final String category;
  final DateTime startDate;
  Map<DateTime, DayStatus> dayStatuses;
  int streakCount;
  int totalDays;
  final bool isCompleted;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.startDate,
    Map<DateTime, DayStatus>? dayStatuses,
    this.streakCount = 0,
    this.totalDays = 0,
    required this.isCompleted,
  }) : dayStatuses = dayStatuses ?? {};

  double get successRate {
    final totalTrackedDays = dayStatuses.keys.length;
    final positiveDays = dayStatuses.values
        .where((status) => status == DayStatus.positive)
        .length;
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

    // Update streak and success rate
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
    int currentStreak = 0;

    // Sort the dates in ascending order
    final sortedDates = dayStatuses.keys.toList()..sort();

    for (final date in sortedDates) {
      final status = dayStatuses[date] ?? DayStatus.empty;

      if (status == DayStatus.positive) {
        currentStreak++;
        streakCount = currentStreak > streakCount ? currentStreak : streakCount;
      } else if (status == DayStatus.negative || status == DayStatus.empty) {
        currentStreak = 0;
      }
    }
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: '', // Placeholder, will be set later
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      dayStatuses: (map['dayStatuses'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(DateTime.parse(key), DayStatus.values[value as int]),
      ),
      streakCount: map['streakCount'] as int,
      totalDays: map['totalDays'] as int,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'dayStatuses': dayStatuses
          .map((key, value) => MapEntry(key.toIso8601String(), value.index)),
      'streakCount': streakCount,
      'totalDays': totalDays,
      'isCompleted': isCompleted,
    };
  }
}
