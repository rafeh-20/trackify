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
  String _selectedFilter = 'All';

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

  void _markHabitComplete(int index) {
    setState(() {
      final today = DateTime.now();
      habits[index].toggleDayStatus(DateTime(today.year, today.month, today.day));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Habit> filteredHabits = _selectedFilter == 'All'
        ? habits
        : habits.where((habit) => habit.category == _selectedFilter).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackify'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.sports, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'Sports';
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.work, color: Colors.orange),
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'Work';
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.list, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'All';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredHabits.isEmpty
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
                    itemCount: filteredHabits.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(filteredHabits[index].id),
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
                          title: Text(filteredHabits[index].title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredHabits[index].description),
                              Text('Success Rate: ${filteredHabits[index].successRate.toStringAsFixed(2)}%'),
                              Text('Streak: ${filteredHabits[index].streakCount} days'),
                            ],
                          ),
                          trailing: GestureDetector(
                            onTap: () => _markHabitComplete(index), // Use the function here
                            child: Icon(
                              habits[index].dayStatuses[DateTime.now()] == DayStatus.positive
                                  ? Icons.check_circle
                                  : habits[index].dayStatuses[DateTime.now()] == DayStatus.negative
                                      ? Icons.cancel
                                      : Icons.radio_button_unchecked,
                              color: habits[index].dayStatuses[DateTime.now()] == DayStatus.positive
                                  ? Colors.green
                                  : habits[index].dayStatuses[DateTime.now()] == DayStatus.negative
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/habit_detail',
                              arguments: filteredHabits[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
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
