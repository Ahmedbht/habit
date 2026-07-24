import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/achievement_model.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Stats & Achievements")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Level & XP card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Level ${habitProvider.level}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("${habitProvider.totalXp} total XP"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick stats row
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: "Habits",
                  value: "${habitProvider.habits.length}",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: "Best Streak",
                  value: "${habitProvider.bestStreakOverall}",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: "Completions",
                  value: "${habitProvider.totalCompletions}",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text("Achievements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: allAchievements.length,
            itemBuilder: (context, index) {
              final achievement = allAchievements[index];
              final isUnlocked = habitProvider.unlockedAchievementIds.contains(achievement.id);

              return Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.amber[100] : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _iconEmoji(achievement.iconName),
                        style: TextStyle(
                          fontSize: 28,
                          color: isUnlocked ? null : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    achievement.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: isUnlocked ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Simple mapping from iconName to emoji for display (keeps this screen simple)
  String _iconEmoji(String iconName) {
    switch (iconName) {
      case 'sprout':
        return '🌱';
      case 'flame':
        return '🔥';
      case 'crown':
        return '👑';
      case 'star':
        return '⭐';
      case 'gem':
        return '💎';
      case 'trophy':
        return '🏆';
      default:
        return '🏅';
    }
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}