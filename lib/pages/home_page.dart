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

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
  }

  void _toggleHabitCompletion(int index) {
    setState(() {
      habits[index].isCompleted = !habits[index].isCompleted;
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
                return Dismissible(
                  key: Key(habits[index].title + index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteHabit(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Habit deleted')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      habits[index].title,
                      style: TextStyle(
                        decoration: habits[index].isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(habits[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _toggleHabitCompletion(index),
                          child: Icon(
                            habits[index].isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: habits[index].isCompleted
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteHabit(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: CustomButton(
        text: "add",
        onPressed: () async {
          final newHabit = await Navigator.pushNamed(context, '/add');
          if (newHabit != null) {
            _addHabit(newHabit as Habit);
          }
        },
      ),
    );
  }
}
