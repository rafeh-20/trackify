import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/habit.dart';

class HabitCalendar extends StatefulWidget {
  final Habit habit;

  const HabitCalendar({super.key, required this.habit});

  @override
  _HabitCalendarState createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.habit.startDate,
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) => widget.habit.dayStatuses[day] == DayStatus.positive,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          widget.habit.toggleDayStatus(selectedDay);
        });
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final status = widget.habit.dayStatuses[day] ?? DayStatus.empty;
          if (status == DayStatus.positive) {
            return const Icon(Icons.check_circle, color: Colors.green, size: 16);
          } else if (status == DayStatus.negative) {
            return const Icon(Icons.cancel, color: Colors.red, size: 16);
          }
          return null;
        },
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
      ),
    );
  }
}