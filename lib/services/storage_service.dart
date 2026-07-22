import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class StorageService {
  static const String _habitsKey = 'habits';
  static const String _totalXpKey = 'total_xp';
  static const String _unlockedAchievementsKey = 'unlocked_achievements';

  //----------Habits----------
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, jsonEncode(jsonList));
  }

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_habitsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Habit.fromJson(json)).toList();
  }

  //----------Total XP----------
  Future<void> saveTotalXp(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalXpKey, xp);
  }

  Future<int> loadTotalXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalXpKey) ?? 0;
  }

  //---------Unlocked Achievements----------
  Future<void> saveUnlockedAchievements(List<String> achievementIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unlockedAchievementsKey, achievementIds);
  }

  Future<List<String>> loadUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedAchievementsKey) ?? [];
  }
}