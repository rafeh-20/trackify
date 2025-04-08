// lib/models/habit.dart
class Habit {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
