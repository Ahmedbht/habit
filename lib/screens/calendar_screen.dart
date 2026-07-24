import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/habit_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Count how many habits were completed on a given day
  int _completionsOnDay(HabitProvider provider, DateTime day) {
    int count = 0;
    for (final habit in provider.habits) {
      if (habit.isCompletedOn(day)) count++;
    }
    return count;
  }

  Color _dayColor(int completions, int totalHabits) {
    if (totalHabits == 0 || completions == 0) return Colors.transparent;
    final ratio = completions / totalHabits;
    if (ratio >= 1.0) return Colors.green;
    if (ratio >= 0.5) return Colors.orange;
    return Colors.redAccent.withOpacity(0.6);
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final completions = _completionsOnDay(habitProvider, day);
                final color = _dayColor(completions, habitProvider.habits.length);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                final completions = _completionsOnDay(habitProvider, day);
                final color = _dayColor(completions, habitProvider.habits.length);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color == Colors.transparent ? Colors.blue[100] : color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedDay != null) _buildSelectedDayDetails(habitProvider),
        ],
      ),
    );
  }

  Widget _buildSelectedDayDetails(HabitProvider provider) {
    final day = _selectedDay!;
    final completedHabits = provider.habits.where((h) => h.isCompletedOn(day)).toList();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${day.day}/${day.month}/${day.year} — ${completedHabits.length}/${provider.habits.length} completed",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: completedHabits.isEmpty
                  ? const Text("No habits completed this day")
                  : ListView(
                      children: completedHabits
                          .map((h) => ListTile(
                                leading: const Icon(Icons.check_circle, color: Colors.green),
                                title: Text(h.name),
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}