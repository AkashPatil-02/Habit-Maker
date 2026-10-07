import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const Inputfield({super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hint: Text(hint)
        ),
      ),
    );
  }
}