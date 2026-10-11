import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/archivedStorageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActivitydetailScreen extends StatelessWidget {
  final Habit habit;
  const ActivitydetailScreen({super.key, required this.habit});

  void archive(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Archive Habit?"),
          content: Text("Are you sure you want to archive '${habit.habit}'?"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await context.read<StorageCubit>().archiveHabit(habit);
                await context.read<Archivedstoragecubit>().archivedEntries();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Color progressbarColor(int days, int target) {
    if (target <= 0) return Colors.blue;
    double ratio = (days / target) * 100;
    if (ratio <= 25) return Colors.red;
    if (ratio <= 50) return Colors.orange;
    if (ratio <= 75) return Colors.yellow;
    if (ratio < 100) return Colors.green;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final progress = habit.target > 0
        ? (habit.days / habit.target).clamp(0.0, 1.0)
        : 0.0;
    final percent = (progress * 100).toStringAsFixed(1);
    final remainingDays = (habit.target - habit.days).clamp(0, habit.target);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Habit Details",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => archive(context),
            icon: const Icon(Icons.archive_outlined, color: Colors.orange, size: 28),
            tooltip: "Archive Habit",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              const Color.fromARGB(255, 30, 24, 50),
              const Color.fromARGB(255, 15, 10, 30),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.25,
                      child: Lottie.asset(
                        'assets/lottie files/fire.json',
                        width: screenWidth,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 18.0,
                          animation: true,
                          percent: progress,
                          backgroundColor: Colors.white10,
                          progressColor: progressbarColor(habit.days, habit.target),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$percent%",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Target: ${habit.target}d",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          habit.habit,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department_rounded,
                                  color: Colors.orangeAccent, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Streak: ${habit.days} Days",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.description_outlined,
                              color: Colors.purpleAccent, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        habit.desc.isNotEmpty ? habit.desc : "No description provided.",
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      context,
                      title: "Current Streak",
                      value: "${habit.days} Days",
                      icon: Icons.bolt_rounded,
                      color: Colors.amber,
                    ),
                    _buildStatCard(
                      context,
                      title: "Target Goal",
                      value: "${habit.target} Days",
                      icon: Icons.flag_rounded,
                      color: Colors.cyanAccent,
                    ),
                    _buildStatCard(
                      context,
                      title: "Remaining",
                      value: "$remainingDays Days",
                      icon: Icons.hourglass_bottom_rounded,
                      color: Colors.orangeAccent,
                    ),
                    _buildStatCard(
                      context,
                      title: "Status",
                      value: habit.days >= habit.target ? "Goal Met! 🎉" : "In Progress",
                      icon: habit.days >= habit.target
                          ? Icons.emoji_events_rounded
                          : Icons.trending_up_rounded,
                      color: habit.days >= habit.target ? Colors.greenAccent : Colors.purpleAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade900.withOpacity(0.6),
                        Colors.indigo.shade900.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.format_quote_rounded,
                          color: Colors.purpleAccent, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Small daily improvements over time lead to stunning results.",
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}