import 'package:flutter/material.dart';

class ActivitydetailScreen extends StatelessWidget {
  final String habit;
  final int days;
  const ActivitydetailScreen({super.key, required this.days,required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(habit),
            Text(days.toString()),

          ],
        ),
      )
    );
  }
}