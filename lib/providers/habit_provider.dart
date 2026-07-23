import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../models/achievement_model.dart';
import '../services/storage_service.dart';

class HabitProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  List<Habit> habits = [];
  int totalXp = 0;
  List<String> unlockedAchievementIds = [];
  List<Achievement> newlyUnlocked = [];

  static const int xpPerCompletion = 10;

  int get level => (totalXp / 100).floor() + 1;
  int get xpIntoCurrentLevel => totalXp % 100;
  int get xpNeededForNextLevel => 100;

  Future<void> loadData() async {
    habits = await _storage.loadHabits();
    totalXp = await _storage.loadTotalXp();
    unlockedAchievementIds = await _storage.loadUnlockedAchievements();
    notifyListeners();
  }

  Future<void> addHabit(String name, String iconName, int colorValue) async {
    final habit = Habit(
      id: _uuid.v4(),
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    habits.add(habit);
    await _storage.saveHabits(habits);
    _checkAchievements();
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    habits.removeWhere((h) => h.id == habitId);
    await _storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = habits.firstWhere((h) => h.id == habitId);
    final today = DateTime.now();

    if (habit.isCompletedToday) {
      habit.completedDates.removeWhere((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
      totalXp -= xpPerCompletion;
      if (totalXp < 0) totalXp = 0;
    } else {
      habit.completedDates.add(today);
      totalXp += xpPerCompletion;
    }

    _recalculateStreak(habit);
    await _storage.saveHabits(habits);
    await _storage.saveTotalXp(totalXp);
    _checkAchievements();
    notifyListeners();
  }

  void _recalculateStreak(Habit habit) {
    if (habit.completedDates.isEmpty) {
      habit.currentStreak = 0;
      return;
    }

    final sortedDates = List<DateTime>.from(habit.completedDates)
      ..sort((a, b) => b.compareTo(a));

    int streak = 1;
    DateTime lastDate = DateTime(
        sortedDates[0].year, sortedDates[0].month, sortedDates[0].day);

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final daysSinceLast = todayDate.difference(lastDate).inDays;

    if (daysSinceLast > 1) {
      habit.currentStreak = 0;
      return;
    }

    for (int i = 1; i < sortedDates.length; i++) {
      final current = DateTime(
          sortedDates[i].year, sortedDates[i].month, sortedDates[i].day);
      final diff = lastDate.difference(current).inDays;

      if (diff == 1) {
        streak++;
        lastDate = current;
      } else if (diff == 0) {
        continue;
      } else {
        break;
      }
    }

    habit.currentStreak = streak;
    if (streak > habit.bestStreak) {
      habit.bestStreak = streak;
    }
  }

  int get totalCompletions =>
      habits.fold(0, (sum, h) => sum + h.completedDates.length);

  int get bestStreakOverall =>
      habits.isEmpty ? 0 : habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);

  void _checkAchievements() {
    newlyUnlocked = [];

    for (final achievement in allAchievements) {
      if (unlockedAchievementIds.contains(achievement.id)) continue;

      bool unlocked = false;
      switch (achievement.type) {
        case AchievementType.habitsCount:
          unlocked = habits.length >= achievement.requiredValue;
          break;
        case AchievementType.streak:
          unlocked = bestStreakOverall >= achievement.requiredValue;
          break;
        case AchievementType.totalXp:
          unlocked = totalXp >= achievement.requiredValue;
          break;
        case AchievementType.completions:
          unlocked = totalCompletions >= achievement.requiredValue;
          break;
      }

      if (unlocked) {
        unlockedAchievementIds.add(achievement.id);
        newlyUnlocked.add(achievement);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      _storage.saveUnlockedAchievements(unlockedAchievementIds);
    }
  }

  void clearNewlyUnlocked() {
    newlyUnlocked = [];
  }
}