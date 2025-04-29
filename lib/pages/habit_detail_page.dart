import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../custom_widgets/habit_calendar.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  void _markAllDays(BuildContext context, DayStatus status) {
    final now = DateTime.now();
    for (var date = habit.startDate;
        date.isBefore(now) || date.isAtSameMomentAs(now);
        date = date.add(const Duration(days: 1))) {
      habit.dayStatuses[date] = status;
    }
    habit.updateStreak();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All days marked as ${status == DayStatus.positive ? "positive" : "negative"}')),
    );
  }

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
            Text('Success Rate: ${habit.successRate.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 18)),
            Text('Current Streak: ${habit.streakCount} days', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _markAllDays(context, DayStatus.positive),
                  child: const Text('Mark All Positive'),
                ),
                ElevatedButton(
                  onPressed: () => _markAllDays(context, DayStatus.negative),
                  child: const Text('Mark All Negative'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: HabitCalendar(habit: habit)),
          ],
        ),
      ),
    );
  }
}