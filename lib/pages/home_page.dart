import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../custom_widgets/custom_button.dart';
import '../models/habit.dart';
import '../pages/habit_detail_page.dart';
import '../pages/motivation_page.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/animations/Trackify.png',
              height: 32,
            ),
            const SizedBox(width: 25),
            const Text(
              'Trackify',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Sign Out',
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/sign_in');
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseService.getHabits(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/empty.json',
                            width: 200),
                        const SizedBox(height: 16),
                        const Text('No habits yet!',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                }

                final habits = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Habit.fromMap(data)
                    ..id = doc.id; // Assign Firestore doc ID
                }).toList();

                List<Habit> filteredHabits = _selectedFilter == 'All'
                    ? habits
                    : habits
                        .where((habit) => habit.category == _selectedFilter)
                        .toList();

                return ListView.builder(
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    return Dismissible(
                      key: Key(habit.id),
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
                      onDismissed: (direction) async {
                        await _databaseService.deleteHabit(user.uid, habit.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${habit.name} deleted')),
                        );
                      },
                      child: ListTile(
                        title: Text(habit.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(habit.description),
                            Text(
                                'Success Rate: ${habit.successRate.toStringAsFixed(2)}%'),
                            Text('Streak: ${habit.streakCount} days'),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () async {
                            final today = DateTime.now();
                            final dateOnly =
                                DateTime(today.year, today.month, today.day);

                            // Toggle the day status
                            habit.toggleDayStatus(dateOnly);

                            // Update the habit in Firestore
                            await _databaseService.updateHabit(
                              user.uid,
                              habit.id,
                              habit.toMap(),
                            );

                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${habit.name} updated')),
                            );
                          },
                          child: Icon(
                            habit.dayStatuses[DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)] ==
                                    DayStatus.positive
                                ? Icons.check_circle
                                : habit.dayStatuses[DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)] ==
                                        DayStatus.negative
                                    ? Icons.cancel
                                    : Icons.radio_button_unchecked,
                            color: habit.dayStatuses[DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)] ==
                                    DayStatus.positive
                                ? Colors.green
                                : habit.dayStatuses[DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)] ==
                                        DayStatus.negative
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HabitDetailPage(
                                habit: habit,
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
            await _databaseService.addHabit(
              user.uid,
              (newHabit as Habit).toMap(),
            );
          }
        },
      ),
    );
  }
}
