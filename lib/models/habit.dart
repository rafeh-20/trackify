// lib/models/habit.dart
class Habit {
  final String id;
  final String title;
  final String description;
  final String category;
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });
}