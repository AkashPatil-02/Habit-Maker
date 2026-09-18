import 'package:habitmaker/model/habit.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class Hivestorage { 
  static const _active = 'habits';
  static const _archive = 'archived';
  
  Future<void> createHabit(String habit,String date, String desc, int target) async {
  final id = const Uuid().v4();
  final box = Hive.box<Habit>(_active);
  final data = Habit(
    days: 25,
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
  return box.values.toList();
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
}