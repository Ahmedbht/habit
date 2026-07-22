class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final int requiredValue; //e: 7 for "7-day streak", 100 for "100 XP"
  final AchievementType type;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.requiredValue,
    required this.type,
  });
}

enum AchievementType {
  streak,       // based on best streak reached
  totalXp,      // based on total XP earned
  habitsCount,  // based on number of habits created
  completions,  // based on total habit completions
}

// Predefined achievement list — static, checked against progress
const List<Achievement> allAchievements = [
  Achievement(
    id: 'first_habit',
    title: 'Getting Started',
    description: 'Create your first habit',
    iconName: 'sprout',
    requiredValue: 1,
    type: AchievementType.habitsCount,
  ),
  Achievement(
    id: 'streak_7',
    title: 'One Week Strong',
    description: 'Reach a 7-day streak',
    iconName: 'flame',
    requiredValue: 7,
    type: AchievementType.streak,
  ),
  Achievement(
    id: 'streak_30',
    title: 'Consistency King',
    description: 'Reach a 30-day streak',
    iconName: 'crown',
    requiredValue: 30,
    type: AchievementType.streak,
  ),
  Achievement(
    id: 'xp_100',
    title: 'XP Hunter',
    description: 'Earn 100 total XP',
    iconName: 'star',
    requiredValue: 100,
    type: AchievementType.totalXp,
  ),
  Achievement(
    id: 'xp_500',
    title: 'XP Master',
    description: 'Earn 500 total XP',
    iconName: 'gem',
    requiredValue: 500,
    type: AchievementType.totalXp,
  ),
  Achievement(
    id: 'completions_50',
    title: 'Half Century',
    description: 'Complete habits 50 times total',
    iconName: 'trophy',
    requiredValue: 50,
    type: AchievementType.completions,
  ),
];