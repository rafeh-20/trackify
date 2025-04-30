import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../custom_widgets/habit_calendar.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;
  final void Function(dynamic) onHabitUpdated;

  const HabitDetailPage({super.key, required this.habit, required this.onHabitUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: HabitCalendar(
                habit: habit,
                onHabitUpdated: () => onHabitUpdated(null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}