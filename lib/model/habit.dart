import 'package:hive_ce/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final int days;

  @HiveField(1)
  final String habit;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String id;

  @HiveField(4)
  final String desc;

  @HiveField(5)
  final bool complete;

  @HiveField(6)
  final int target;

  Habit({
    required this.days,
    required this.habit,
    required this.date,
    required this.id,
    required this.desc,
    required this.complete,
    required this.target
  });
}