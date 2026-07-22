import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Habit {
  final String id;
  String name;
  String iconName; //stores icon name as string, ex."droplet","book","activity"
  int colorValue;
  DateTime createdAt;
  List<DateTime> completedDates;
  int currentStreak;
  int bestStreak;

  Habit({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.createdAt,
    List<DateTime>? completedDates,
    this.currentStreak = 0,
    this.bestStreak = 0,
  }) : completedDates = completedDates ?? [];

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  bool get isCompletedToday => isCompletedOn(DateTime.now());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      iconName: json['iconName'],
      colorValue: json['colorValue'],
      createdAt: DateTime.parse(json['createdAt']),
      completedDates: (json['completedDates'] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
      currentStreak: json['currentStreak'],
      bestStreak: json['bestStreak'],
    );
  }
}

// Curated list of icon options for habit creation (name -> IconData)
final Map<String, IconData> habitIconOptions = {
  'droplet': LucideIcons.droplet,
  'book': LucideIcons.book,
  'dumbbell': LucideIcons.dumbbell,
  'moon': LucideIcons.moon,
  'brain': LucideIcons.brain,
  'code': LucideIcons.code,
  'heart': LucideIcons.heart,
  'coffee': LucideIcons.coffee,
  'sun': LucideIcons.sun,
  'pill': LucideIcons.pill,
  'utensils': LucideIcons.utensils,
  'bike': LucideIcons.bike,
};

IconData getHabitIcon(String iconName) {
  return habitIconOptions[iconName] ?? LucideIcons.circleCheck;
}