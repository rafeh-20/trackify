import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/habit.dart';

class HabitCalendar extends StatefulWidget {
  final Habit habit;
  final VoidCallback onHabitUpdated;

  const HabitCalendar(
      {super.key, required this.habit, required this.onHabitUpdated});

  @override
  HabitCalendarState createState() => HabitCalendarState();
}

class HabitCalendarState extends State<HabitCalendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.habit.startDate,
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.all,
      enabledDayPredicate: (day) {
        return !day.isAfter(DateTime.now()) &&
            !day.isBefore(widget.habit.startDate);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          final dateOnly =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
          widget.habit.toggleDayStatus(dateOnly);
          widget.onHabitUpdated();
        });
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (day.isAfter(DateTime.now()) ||
              day.isBefore(widget.habit.startDate)) {
            return null;
          }
          final dateOnly = DateTime(day.year, day.month, day.day);
          final status = widget.habit.dayStatuses[dateOnly] ?? DayStatus.empty;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                  height: 4),
              Icon(
                status == DayStatus.positive
                    ? Icons.check_circle
                    : status == DayStatus.negative
                        ? Icons.cancel
                        : Icons.radio_button_unchecked,
                color: status == DayStatus.positive
                    ? Colors.green
                    : status == DayStatus.negative
                        ? Colors.red
                        : Colors.grey,
                size: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}
