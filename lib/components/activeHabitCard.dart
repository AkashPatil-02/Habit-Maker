import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/archivedStorageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:habitmaker/screens/activityDetail.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Activehabitcard extends StatelessWidget {
  final Habit habit;
  const Activehabitcard({super.key, required this.habit});

  void archive(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Archive Habit?"),
          content: Text("Do you want to archive '${habit.habit}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                await context.read<StorageCubit>().archiveHabit(habit);
                await context.read<Archivedstoragecubit>().archivedEntries();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Archive", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  double calculateProgress() {
    if (habit.target <= 0) return 0.0;
    return (habit.days / habit.target).clamp(0.0, 1.0);
  }

  Color progressbarColor(int days, int target) {
    if (target <= 0) return Colors.blue;
    double percentage = (days / target) * 100;
    if (percentage <= 25) return Colors.redAccent;
    if (percentage <= 50) return Colors.orangeAccent;
    if (percentage <= 75) return Colors.amber;
    if (percentage < 100) return Colors.lightGreenAccent;
    return Colors.cyanAccent;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth > 400 ? 360.0 : screenWidth - 32;
    final progress = calculateProgress();
    final percentText = (progress * 100).toStringAsFixed(1);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivitydetailScreen(habit: habit)),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Lottie.asset(
                    'assets/lottie files/fire.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(200, 20, 15, 38),
                      const Color.fromARGB(245, 12, 10, 25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: habit.complete
                                ? Colors.green.withOpacity(0.2)
                                : Colors.purple.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: habit.complete
                                  ? Colors.greenAccent.withOpacity(0.4)
                                  : Colors.purpleAccent.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                habit.complete
                                    ? Icons.check_circle_rounded
                                    : Icons.local_fire_department_rounded,
                                color: habit.complete ? Colors.greenAccent : Colors.orangeAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                habit.complete ? "Completed Today" : "${habit.days} Days Streak",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => archive(context),
                          icon: const Icon(Icons.archive_outlined, size: 26, color: Colors.orangeAccent),
                          tooltip: "Archive",
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CircularPercentIndicator(
                      radius: 65.0,
                      lineWidth: 14.0,
                      animation: true,
                      percent: progress,
                      backgroundColor: Colors.white12,
                      progressColor: progressbarColor(habit.days, habit.target),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$percentText%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Goal: ${habit.target}d",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Text(
                          habit.habit,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (habit.desc.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.desc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Lottie.asset(
                              'assets/lottie files/completebg.json',
                              fit: BoxFit.cover,
                            ),
                            Material(
                              color: habit.complete
                                  ? Colors.green.withOpacity(0.3)
                                  : const Color.fromARGB(255, 175, 128, 233).withAlpha(30),
                              child: InkWell(
                                onTap: habit.complete
                                    ? null
                                    : () async {
                                        await HapticFeedback.vibrate();
                                        await context.read<StorageCubit>().markComplete(habit);
                                      },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        habit.complete
                                            ? Icons.check_circle_rounded
                                            : Icons.done_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        habit.complete ? "C O M P L E T E D" : "C O M P L E T E",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}