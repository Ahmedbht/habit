import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import '../models/habit_model.dart';
import '../models/achievement_model.dart';
import 'stats_screen.dart';
import 'calendar_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<HabitProvider>(context, listen: false).loadData());
  }
  void _showAchievementPopup(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🎉 Achievement Unlocked!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(achievement.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(achievement.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nice!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Quest"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Level ${habitProvider.level}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${habitProvider.xpIntoCurrentLevel} / ${habitProvider.xpNeededForNextLevel} XP"),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: habitProvider.xpIntoCurrentLevel / habitProvider.xpNeededForNextLevel,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: habitProvider.habits.isEmpty
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
                            onPressed: () async {
                              await habitProvider.toggleHabitCompletion(habit.id);
                              if (habitProvider.newlyUnlocked.isNotEmpty) {
                                _showAchievementPopup(habitProvider.newlyUnlocked.first);
                                habitProvider.clearNewlyUnlocked();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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