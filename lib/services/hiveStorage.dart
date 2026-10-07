import 'package:habitmaker/model/habit.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class Hivestorage { 
  static const _active = 'habits';
  static const _archive = 'archived';

  String _formatDate(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }
  
  Future<void> createHabit(String habit,String date, String desc, int target) async {
  final id = const Uuid().v4();
  final box = Hive.box<Habit>(_active);
  final data = Habit(
    days: 0,
    habit: habit,
    date: date,
    id: id,
    desc: desc,
    complete: false,
    target: target
  );
  await box.put(id, data);
  }

  Future<List<Habit>> getEntries() async {
  final box = Hive.box<Habit>(_active);
  final today = DateTime.now();
  final todayDate = DateTime(today.year,today.month,today.day);
  List<Habit> list=[];
  for(var habit in box.values){
    Habit updated = habit;
    if(habit.lastCompletion!=null){
      final lastDate = _parseDate(habit.lastCompletion!);
      final difference = todayDate.difference(lastDate).inDays;

      if(difference>1){
        updated = habit.copyWith(days: 0,complete: false);
        await box.put(habit.id,updated);
      }
      else if(difference==1 && habit.complete){
        updated = habit.copyWith(complete: false);
        await box.put(habit.id, updated);
      }
    }
    list.add(updated);
  }
  return list;
  }
  Future<List<Habit>> getArchivedEntries()async{
    final box = Hive.box<Habit>(_archive);
    return box.values.toList();
  }
  Future<void> archiveHabit(Habit habit) async {
  final activeBox = Hive.box<Habit>(_active);
  final archiveBox = Hive.box<Habit>(_archive);

  await archiveBox.put(habit.id, habit);
  await activeBox.delete(habit.id);

  }
  Future<void> deleteArchive(Habit habit)async{
    final archiveBox = Hive.box<Habit>(_archive);
    await archiveBox.delete(habit.id);
  }

  Future<void> completedHabitToday(Habit habit)async{
    final box = Hive.box<Habit>(_active);
    final today = DateTime.now();
    final todaystr = _formatDate(today);
    final todayDate = DateTime(today.year,today.month,today.day);

    if(habit.lastCompletion==todaystr) return;

    int newStreak=1;
    if(habit.lastCompletion!=null){
      final lastDate = _parseDate(habit.lastCompletion!);
      final difference = todayDate.difference(lastDate).inDays;
      if(difference==1){
        newStreak = habit.days+1;
      }
    }
    final updatedHabit = habit.copyWith(
      days: newStreak,
      complete: true,
      lastCompletion: todaystr,
    );
    await box.put(habit.id,updatedHabit);
  }
}