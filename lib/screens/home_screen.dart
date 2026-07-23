import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';

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
              padding: const EdgeInsets.all(12),
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                final color = Color(habit.colorValue);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(getHabitIcon(habit.iconName), color: color),
                    ),
                    title: Text(habit.name),
                    subtitle: habit.currentStreak > 0
                        ? Text("🔥 ${habit.currentStreak} day streak")
                        : const Text("No streak yet"),
                    trailing: IconButton(
                      icon: Icon(
                        habit.isCompletedToday
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: habit.isCompletedToday ? color : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () {
                        habitProvider.toggleHabitCompletion(habit.id);
                      },
                    ),
                  ),
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