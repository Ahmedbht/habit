import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved habits when screen first opens
    Future.microtask(() =>
        Provider.of<HabitProvider>(context, listen: false).loadData());
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Habit Quest")),
      body: habitProvider.habits.isEmpty
          ? const Center(child: Text("No habits yet. Add one!"))
          : ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                return ListTile(
                  title: Text(habit.name),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}