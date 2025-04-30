import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';
import 'pages/add_habit_page.dart';
import 'pages/habit_detail_page.dart';
import 'models/habit.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackify',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const HomePage(),
        '/add': (context) => const AddHabitPage(),
        '/habit_detail': (context) {
          final habit = ModalRoute.of(context)!.settings.arguments as Habit;
          return HabitDetailPage(
            habit: habit,
            onHabitUpdated: (updatedHabit) {
              (context as Element).markNeedsBuild();
            },
          );
        },
      },
    );
  }
}
