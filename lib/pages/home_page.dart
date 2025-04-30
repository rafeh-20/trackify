import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../custom_widgets/custom_button.dart';
import '../models/habit.dart';
import '../pages/habit_detail_page.dart';
import '../pages/motivation_page.dart';

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
      final dateOnly = DateTime(today.year, today.month, today.day);
      habits[index].toggleDayStatus(dateOnly);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb, color: Colors.yellow),
            tooltip: 'Motivation',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotivationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: 'Sports',
                  child: IconButton(
                    icon: const Icon(Icons.sports, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Sports';
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'Work',
                  child: IconButton(
                    icon: const Icon(Icons.work, color: Colors.orange),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Work';
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'Education',
                  child: IconButton(
                    icon: const Icon(Icons.school, color: Colors.purple),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Education';
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'Other',
                  child: IconButton(
                    icon: const Icon(Icons.category, color: Colors.brown),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Other';
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'All',
                  child: IconButton(
                    icon: const Icon(Icons.list, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'All';
                      });
                    },
                  ),
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
                            onTap: () => _markHabitComplete(index),
                            child: Icon(
                              filteredHabits[index].dayStatuses[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)] == DayStatus.positive
                                  ? Icons.check_circle
                                  : filteredHabits[index].dayStatuses[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)] == DayStatus.negative
                                      ? Icons.cancel
                                      : Icons.radio_button_unchecked,
                              color: filteredHabits[index].dayStatuses[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)] == DayStatus.positive
                                  ? Colors.green
                                  : filteredHabits[index].dayStatuses[DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)] == DayStatus.negative
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitDetailPage(
                                  habit: filteredHabits[index],
                                  onHabitUpdated: (dynamic _) {
                                    setState(() {});
                                  },
                                ),
                              ),
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
