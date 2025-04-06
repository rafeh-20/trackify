// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../custom_widgets/custom_button.dart';
import '../models/habit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];

  void _addHabit(Habit habit) {
    setState(() {
      habits.add(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/empty.json', width: 200),
                  const SizedBox(height: 16),
                  const Text('No habits yet!', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(habits[index].title),
                  subtitle: Text(habits[index].description),
                  trailing: Icon(
                    habits[index].isCompleted
                        ? Icons.check_circle
                        : Icons.circle,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await Navigator.pushNamed(context, '/add');
          if (newHabit != null) {
            _addHabit(newHabit as Habit);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
