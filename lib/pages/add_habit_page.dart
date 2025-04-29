// lib/pages/add_habit_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../utils/utils.dart';
import '../custom_widgets/custom_button.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Sports';
  DateTime? _startDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.isEmpty || _descController.text.isEmpty || _startDate == null) {
      showError(context, "Please fill in all fields");
      return;
    }
    final newHabit = Habit(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descController.text,
      category: _selectedCategory,
      startDate: _startDate!,
    );
    Navigator.pop(context, newHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: 'Sports', child: Text('Sports')),
                DropdownMenuItem(value: 'Work', child: Text('Work')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Start Date:'),
                const SizedBox(width: 10),
                Text(
                  _startDate == null ? 'Select a date' : DateFormat.yMMMd().format(_startDate!),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _startDate = selectedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Save", onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
